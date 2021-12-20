# frozen_string_literal: true

module App
  # Handles user facing market stuff
  class MarketController < AppController

    def new
      @market = Market.new
    end

    def create
      safe_params = params.require(:create).permit(:display_name, :path_name, :email)

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

      redirect_to app_market_path @market.id

    end

    def show
      @market = Market.find params[:id]
    end

  end
end

