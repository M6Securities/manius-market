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
  validates_presence_of :order
  validates :quantity,
            numericality: {
              only_integer: true,
              greater_than: 0
            }
end
