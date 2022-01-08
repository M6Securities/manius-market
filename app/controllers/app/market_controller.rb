# frozen_string_literal: true

module App
  # Handles user facing market stuff
  class MarketController < AppController
    before_action :find_market, except: %i[index datatable new create]

    def new
      @market = Market.new
    end

    def create
      safe_params = params.require(:create).permit(:display_name, :path_name, :email, :stripe_publishable_key, :stripe_secret_key, :default_currency)

      @market = Market.new(safe_params)

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

      redirect_to app_market_path @market
    end

    def show
      render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::OWNER, @market)
    end

    def edit
      render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::OWNER, @market)
    end

    def update
      return render 'error/unauthorized', status: :unauthorized, layout: 'error' unless current_user.permission?(UserMarketPermission::OWNER, @market)

      safe_params = params.require(:update).permit(:display_name, :email, :stripe_publishable_key, :stripe_secret_key)

      return render :edit, status: :unprocessable_entity unless @market.update safe_params.except(:stripe_publishable_key, :stripe_secret_key)

      # only update the stripe keys if they are present
      if safe_params[:stripe_publishable_key].present? && safe_params[:stripe_secret_key].present?
        @market.update_attribute(:stripe_publishable_key, safe_params[:stripe_publishable_key])
        @market.update_attribute(:stripe_secret_key, safe_params[:stripe_secret_key])
      end

      flash[:success] = 'Market updated'
      render :edit
    end

    private

    def find_market
      @market = Market.find_by id: params[:id]
    end
  end
end
