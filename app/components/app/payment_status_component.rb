# frozen_string_literal: true

module App
  # renders a badge of the payment status
  class PaymentStatusComponent < ViewComponent::Base
    def initialize(payment_status)
      super
      @payment_status = payment_status
    end
  end
end
