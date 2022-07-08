# frozen_string_literal: true

module Api
  # handles all webhooks from connected services. NOT our own webhooks, should we write any
  class WebhookController < ApiController
    skip_before_action :verify_authenticity_token
    before_action :current_market

    def current_market
      @current_market = Market.find_by(path_name: request.subdomain)
      @current_market = Market.first if @current_market.nil?
    end
  end
end
