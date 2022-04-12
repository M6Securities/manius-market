# frozen_string_literal: true

#
# Represents an item in an order
class OrderItem < ApplicationRecord
  # Associations
  # --------------------------------------------------------------------------------------------------------------------
  belongs_to :order
  belongs_to :product

  # Validations
  # --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :order, :product
  validates :quantity,
            numericality: {
              only_integer: true,
              greater_than: 0
            }

  # Methods
  # --------------------------------------------------------------------------------------------------------------------

  # returns a money object of the price
  def price_total(currency)
    Money.from_cents((product.product_price_from_currency(currency).price.cents * quantity), currency)
  end
end
