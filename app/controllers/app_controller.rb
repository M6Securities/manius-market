# frozen_string_literal: true

# parent for everything under the app scope
class AppController < ApplicationController
  layout :set_layout

  before_action :authenticate_user!
  before_action :check_user_enabled
  before_action :set_market_dropdown_false

  def current_market
    puts 'Current Market...'
    @current_market = Market.find session[:market_id] unless session[:market_id].blank?
    @current_market = nil unless current_user.markets.include?(@current_market) # unless @current_market.nil?
    @current_market = current_user.markets.first if @current_market.nil?

    # redirect_to new_app_market_space_market_path if @current_market.nil?
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

  def get_user_market_permissions
    @user_market_permissions = current_user.user_market_permissions.find_by(market_id: @current_market.id)
  end

  # given an array of keys, a model object, a hash of the new attributes, and a user_market_permission object, update and log the changes
  def log_model_updates(keys, model, changes, user_market_permission)
    keys.each do |key|
      next if changes[key].nil?

      next if changes[key].to_s == model[key].to_s

      model.action_logs.create(
        action: "Updated \"#{key}\" from \"#{model[key]}\" to \"#{changes[key]}\"",
        user_market_permission:
      )

      model[key] = changes[key]
    end

    model.save
  end

  def set_market_dropdown_false
    @market_dropdown = false
  end

  def set_market_dropdown_true
    @market_dropdown = true
  end

  private

  def set_layout
    return 'turbo_frame' if turbo_frame_request?

    'app'
  end
end
