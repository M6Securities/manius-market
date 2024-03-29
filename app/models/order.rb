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

  enum :payment_status, {
    none: PS_NONE,
    requires_payment_method: PS_REQUIRES_PAYMENT_METHOD,
    requires_confirmation: PS_REQUIRES_CONFIRMATION,
    requires_action: PS_REQUIRES_ACTION,
    processing: PS_PROCESSING,
    requires_capture: PS_REQUIRES_CAPTURE,
    cancelled: PS_CANCELLED,
    succeeded: PS_SUCCEEDED
  }, prefix: true, default: :payment_status_none # ignore the warning this is right

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

  enum :status, {
    not_acknowledged: OS_NOT_ACKNOWLEDGED,
    acknowledged: OS_ACKNOWLEDGED,
    processing: OS_PROCESSING,
    shipped: OS_SHIPPED,
    delivered: OS_DELIVERED,
    cancelled: OS_CANCELLED
  }, prefix: :status # ignore the warning this is right

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
  has_one :address, as: :addressable, dependent: :destroy

  # Validations
  # --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :customer
  validates_presence_of :address
  # validates :payment_status, inclusion: { in: PS_ARRAY }
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
