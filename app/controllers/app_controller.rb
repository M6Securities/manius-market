# frozen_string_literal: true

class AppController < ApplicationController
  layout 'app'

  before_action :authenticate_user!
  before_action :check_user_enabled
  before_action :current_market

  def current_market
    @current_market = Market.find session[:market_id]
    @current_market = nil unless current_user.markets.include?(@current_market) # unless @current_market.nil?
    @current_market = current_user.markets.first if @current_market.nil?
  end

  def set_market
    market = Market.find_by(path_name: params.require(:market).permit(:path)[:path])

    session[:market_id] = market.id
    @current_market = market

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to app_market_path(market.id) }
    end

    redirect_to app_market_path(market.id)
  end

end
