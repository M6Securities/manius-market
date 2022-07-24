# frozen_string_literal: true

module App
  class MarketSpaceController < AppController
    before_action :require_market
    before_action :current_market
    before_action :get_user_market_permissions
    before_action :create_market_if_not_exist
    before_action :set_market_dropdown_true

    private

    def create_market_if_not_exist
      redirect_to new_app_market_space_market_path if @current_market.nil?
    end
  end
end
