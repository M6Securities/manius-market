# frozen_string_literal: true

# parent for everything under the app scope
class AppController < ApplicationController
  layout :set_layout

  before_action :authenticate_user!
  before_action :check_user_enabled
  before_action :current_market

  def current_market
    @current_market = Market.find session[:market_id] unless session[:market_id].blank?
    @current_market = nil unless current_user.markets.include?(@current_market) # unless @current_market.nil?
    @current_market = current_user.markets.first if @current_market.nil?
  end

  def set_market
    market = Market.find_by(path_name: params.require(:market).permit(:path)[:path])

    session[:market_id] = market.id
    @current_market = market

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to app_market_space_market_path(market.id) }
    end

    redirect_to app_market_space_market_path(market.id)
  end

  def require_market
    return redirect_to app_dashboard_index_path unless current_user.has_market?
  end

  private

  def set_layout
    return 'turbo_frame' if turbo_frame_request?

    'app'
  end
end
