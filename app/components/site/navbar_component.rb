# frozen_string_literal: true

module Site
  class NavbarComponent < ViewComponent::Base
    def initialize(customer, market)
      super
      puts "Customer ID: #{customer.id}"

      @customer = customer
      @user = if @customer.nil?
                nil
              else
                @customer.user
              end
      @market = market
    end
  end
end
