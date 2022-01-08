# frozen_string_literal: true

# Parent controller for everything public facing
class SiteController < ApplicationController
  before_action :current_market
  before_action :current_customer

  layout 'site'

  def current_market
    @current_market = Market.find_by(path_name: request.subdomain)
    @current_market = Market.first if @current_market.nil?
  end

  def current_customer
    # TODO: Cache this query?
    if current_user.nil?
      @current_customer = Customer.find_by(session_id: session[:session_id])
      @current_customer = @current_market.customers.create(session_id: session[:session_id], real: false) if @current_customer.nil?
    else
      @current_customer = current_user.customers.find_by(market_id: @current_market.id)
      @current_customer = @current_market.customers.create(session_id: session[:session_id], user_id: current_user.id, real: true) if @current_customer.nil?
    end
  end
end
