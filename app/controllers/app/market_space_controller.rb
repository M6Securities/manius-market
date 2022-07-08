# frozen_string_literal: true

module App
  class MarketSpaceController < AppController
    before_action :require_market
    before_action :current_market
    before_action :get_user_market_permissions
  end
end
