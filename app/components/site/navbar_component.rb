# frozen_string_literal: true

class Site::NavbarComponent < ViewComponent::Base
  def initialize(user, market)
    @user = user
    @market = market
  end
end
