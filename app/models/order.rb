# frozen_string_literal: true

#
# Represents a single order with a single payment, tied to a customer.
class Order < ApplicationRecord
  # Constants
  # --------------------------------------------------------------------------------------------------------------------

  # Payment Status
  PS_NONE = 0 # When the order is created, but no payment has been attempted.
  PS_REQUIRES_PAYMENT_METHOD = 1
  PS_REQUIRES_CONFIRMATION = 2
  PS_REQUIRES_ACTION = 3
  PS_PROCESSING = 4
  PS_REQUIRES_CAPTURE = 5
  PS_CANCELED = 6
  PS_SUCCEEDED = 7

  PS_ARRAY = [
    PS_NONE,
    PS_REQUIRES_PAYMENT_METHOD,
    PS_REQUIRES_CONFIRMATION,
    PS_REQUIRES_ACTION,
    PS_PROCESSING,
    PS_REQUIRES_CAPTURE,
    PS_CANCELED,
    PS_SUCCEEDED
  ].freeze

  # Order Status
  OS_NOT_ACKNOWLEDGED = 0
  OS_ACKNOWLEDGED = 1
  OS_PROCESSING = 2
  OS_SHIPPED = 3
  OS_DELIVERED = 4
  OS_CANCELED = 5

  OS_ARRAY = [
    OS_NOT_ACKNOWLEDGED,
    OS_ACKNOWLEDGED,
    OS_PROCESSING,
    OS_SHIPPED,
    OS_DELIVERED,
    OS_CANCELED
  ].freeze

  # Associations
  # --------------------------------------------------------------------------------------------------------------------
  belongs_to :customer
  has_many :order_items, dependent: :destroy

  # Validations
  # --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :customer
  validates :payment_status, inclusion: { in: PS_ARRAY }

  # Methods
  # --------------------------------------------------------------------------------------------------------------------

  def market
    customer.market
  end

  def user
    customer.user
  end
end
