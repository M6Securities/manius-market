# frozen_string_literal: true

# the navigation bar on the app
class AppNavbarComponent < ViewComponent::Base

  def initialize(user, market)
    super
    @user = user
    @market = market
  end

  def render?
    super

    return false if @user.nil? || @market.nil?

    true
  end


end
