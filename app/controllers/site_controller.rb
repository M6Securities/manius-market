class SiteController < ApplicationController
  before_action :current_market

  def current_market
    puts request.subdomain
    @current_market = Market.find_by(path_name: request.subdomain)
    @current_market = Market.first if @current_market.nil?
  end
end
