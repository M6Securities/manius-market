class CartItem < ApplicationRecord
  # Associations
  # ------------------------------------------------------------
  belongs_to :customer
  belongs_to :product

  # Validations
  # ------------------------------------------------------------
  validates_presence_of :customer, :product
  validates :quantity,
            presence: true,
            numericality: { greater_than: 0 }

  def market
    customer.market
  end
end
