# frozen_string_literal: true

module App
  class MarketSpaceController < AppController
    before_action :require_market
  end
end
