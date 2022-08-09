# frozen_string_literal: true

module App
  module MarketSpace
    # Handles user facing market stuff
    class MarketController < MarketSpaceController
      before_action :find_market, except: %i[index datatable new create]
      skip_before_action :current_market, :get_user_market_permissions, :require_market, only: %i[new create]

      def new
        @market = Market.new
      end

      def create
        safe_params = params.require(:create).permit(:display_name, :path_name, :email, :stripe_publishable_key, :stripe_secret_key, :default_currency, :stripe_webhook_secret)

        @market = Market.new safe_params

        if @market.invalid?
          return respond_to do |format|
            format.html { render :new, status: :unprocessable_entity }
          end
        end

        @market.save

        current_user.user_market_permissions.create(
          market_id: @market.id,
          formatted_permissions: UserMarketPermission.format_permissions([UserMarketPermission::OWNER])
        )

        redirect_to app_market_space_market_path @market
      end

      def show
        render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::OWNER, @market)
      end

      def edit
        render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::OWNER, @market)
      end

      def update
        return render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::OWNER, @market)

        # normally I'd do safe params but in this case params are generated on the fly, so no can do.

        # example params:
        # Parameters: {"authenticity_token"=>"[FILTERED]", "update"=>{"display_name"=>"Dalen's Market", "email"=>"cloud@m6securities.com", "default_currency"=>"USD", "payment_gateways"=>[{"name"=>"Stripe", "gateway"=>"stripe", "stripe"=>{"publishable_key"=>"[FILTERED]", "secret_key"=>"[FILTERED]"}}]}, "locale"=>"en", "id"=>"750858574031683585"}

        display_name = params[:update][:display_name]
        email = params[:update][:email]
        default_currency = params[:update][:default_currency]
        payment_gateways = params[:update][:payment_gateways]

        @market.assign_attributes(display_name:, email:, default_currency:)

        # now update the payment gateways
        # we need to make sure that the array that was submitted matches the array that is in the db
        # if a record isn't submitted but in the db, then we delete it
        # if a submitted record has valid credentials, then we update it
        # if a submitted record has invalid credentials, then we do nothing
        # if a submitted record has no credentials, then we do nothing
        # credentials need to match PaymentGateway::GATEWAY_CONFIG

        # if no payment gateways are submitted, then we delete all of them, and disable the market
        if payment_gateways.nil?
          @market.payment_gateways.destroy_all
          @market.update(enabled: false)

          flash[:success] = 'Market updated' if @market.save

          return render :edit
        end

        payment_gateways.each do |payment_gateway|
          # find the record in the db
          db_payment_gateway = @market.payment_gateways.find_by(gateway: payment_gateway[:gateway])

          # check to see if the gateway exists
          new_gateway = false
          if db_payment_gateway.nil?
            # if the gateway doesn't exist, then we need to create it
            db_payment_gateway = @market.payment_gateways.new(gateway: payment_gateway[:gateway])
          end

          # check to see if the credentials are valid
          gateway_creds = payment_gateway["#{payment_gateway[:gateway]}"]

          # compare the keys to GateWayConfig
          valid_creds = true
          PaymentGateway::GATEWAY_CONFIG[payment_gateway[:gateway].to_sym].each do |key|
            if gateway_creds[key].blank?
              valid_creds = false
              break
            end
          end

          unless valid_creds
            # if the credentials are invalid, then we do nothing. if it's a new gateway, then we delete it
            db_payment_gateway.destroy if new_gateway
            next
          end

          # if the credentials are valid, then we update the record
          db_payment_gateway.assign_attributes(credentials: gateway_creds)

          # check to see if the db_payment_gateway is valid. If not, then let the user now
          flash[:error] = db_payment_gateway.errors.full_messages.join(', ') unless db_payment_gateway.valid?
        end

        # now we remove deleted payment gateways

        @market.payment_gateways.each do |payment_gateway|
          payment_gateway.destroy unless payment_gateways.any? { |pg| pg[:gateway] == payment_gateway.gateway }
        end

        flash[:success] = 'Market updated' if @market.save

        render :edit
      end

      private

      def find_market
        puts 'Finding Market'
        @market = Market.find_by id: params[:id]
      end
    end
  end
end
