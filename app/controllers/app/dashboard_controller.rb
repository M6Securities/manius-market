# frozen_string_literal: true

module App
  # first thing the user sees when logging in
  class DashboardController < AppController
    before_action :current_market
  end
end
