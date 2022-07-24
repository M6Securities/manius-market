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
  PS_CANCELLED = 6
  PS_SUCCEEDED = 7

  enum :payment_status, %i[none requires_payment_method requires_confirmation requires_action processing requires_capture cancelled succeeded], prefix: :payment_status # ignore the warning this is right

  PS_ARRAY = [
    PS_NONE,
    PS_REQUIRES_PAYMENT_METHOD,
    PS_REQUIRES_CONFIRMATION,
    PS_REQUIRES_ACTION,
    PS_PROCESSING,
    PS_REQUIRES_CAPTURE,
    PS_CANCELLED,
    PS_SUCCEEDED
  ].freeze

  PS_OPTIONS_ARRAY = [
    ['None', PS_NONE],
    ['Requires Payment Method', PS_REQUIRES_PAYMENT_METHOD],
    ['Requires Confirmation', PS_REQUIRES_CONFIRMATION],
    ['Requires Action', PS_REQUIRES_ACTION],
    ['Processing', PS_PROCESSING],
    ['Requires Capture', PS_REQUIRES_CAPTURE],
    ['Canceled', PS_CANCELLED],
    ['Succeeded', PS_SUCCEEDED]
  ].freeze

  # Order Status
  OS_NOT_ACKNOWLEDGED = 0
  OS_ACKNOWLEDGED = 1
  OS_PROCESSING = 2
  OS_SHIPPED = 3
  OS_DELIVERED = 4
  OS_CANCELLED = 5

  enum :status, %i[waiting_acknowledgement acknowledged processing shipped delivered cancelled], prefix: :status # ignore the warning this is right

  OS_ARRAY = [
    OS_NOT_ACKNOWLEDGED,
    OS_ACKNOWLEDGED,
    OS_PROCESSING,
    OS_SHIPPED,
    OS_DELIVERED,
    OS_CANCELLED
  ].freeze

  OS_OPTIONS_ARRAY = [
    ['Waiting Acknowledgement', OS_NOT_ACKNOWLEDGED],
    ['Acknowledged', OS_ACKNOWLEDGED],
    ['Processing', OS_PROCESSING],
    ['Shipped', OS_SHIPPED],
    ['Delivered', OS_DELIVERED],
    ['Cancelled', OS_CANCELLED]
  ].freeze

  # Associations
  # --------------------------------------------------------------------------------------------------------------------
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :action_logs, as: :loggable, dependent: :destroy

  # Validations
  # --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :customer
  validates :payment_status, inclusion: { in: PS_ARRAY }
  validates :status, inclusion: { in: statuses.keys }

  # Methods
  # --------------------------------------------------------------------------------------------------------------------

  monetize :total_price_cents, allow_nil: true

  def market
    customer.market
  end

  def user
    customer.user
  end
end
