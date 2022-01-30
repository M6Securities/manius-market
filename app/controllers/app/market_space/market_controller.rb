# frozen_string_literal: true

module App
  module MarketSpace
    # Handles user facing market stuff
    class MarketController < MarketSpaceController
      before_action :find_market, except: %i[index datatable new create]

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

        safe_params = params.require(:update).permit(:display_name, :email, :stripe_publishable_key, :stripe_secret_key, :default_currency, :stripe_webhook_secret)

        return render :edit, status: :unprocessable_entity unless (@market.attributes = safe_params.except(:stripe_publishable_key, :stripe_secret_key, :stripe_webhook_secret))

        # only update the stripe keys if they are present
        if safe_params[:stripe_publishable_key].present? && safe_params[:stripe_secret_key].present?
          @market.stripe_publishable_key = safe_params[:stripe_publishable_key]
          @market.stripe_secret_key = safe_params[:stripe_secret_key]
        end
        @market.stripe_webhook_secret = safe_params[:stripe_webhook_secret] if safe_params[:stripe_webhook_secret].present?

        flash[:success] = 'Market updated' if @market.save

        render :edit
      end

      private

      def find_market
        @market = ApplicationRecord::Market.find_by id: params[:id]
      end
    end
  end
end
