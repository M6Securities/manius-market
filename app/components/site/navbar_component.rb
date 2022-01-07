# frozen_string_literal: true

module Site
  class NavbarComponent < ViewComponent::Base
    def initialize(customer, market)
      super
      @customer = customer
      @user = @customer.user
      @market = market
    end
  end
end
