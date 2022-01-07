# frozen_string_literal: true

#
# Represents a single order with a single payment, tied to a customer.
class Order < ApplicationRecord
  # Associations
  # --------------------------------------------------------------------------------------------------------------------
  belongs_to :customer
  has_many :order_items, dependent: :destroy

  # Validations
  # --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :customer

  # Methods
  # --------------------------------------------------------------------------------------------------------------------

  def market
    customer.market
  end

  def user
    customer.user
  end
end
