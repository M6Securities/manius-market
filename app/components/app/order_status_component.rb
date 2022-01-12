# frozen_string_literal: true

module App
  # renders a badge of the order status
  class OrderStatusComponent < ViewComponent::Base
    def initialize(status)
      super
      @status = status
    end
  end
end
