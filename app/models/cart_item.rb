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

  # returns a money object of the price
  def price_total(currency)
    Money.from_cents((product.product_price_from_currency(currency).price.cents * quantity), currency)
  end
end
