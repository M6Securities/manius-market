class CartItem < ApplicationRecord
  # Associations
  # ------------------------------------------------------------
  belongs_to :customer
  belongs_to :product

  # Validations
  # ------------------------------------------------------------
  # validates_presence_of :customer, :product # technically not needed because it's done in validate_same_markets
  validates :quantity,
            presence: true,
            numericality: { greater_than: 0 }
  validate :validate_same_markets

  # Methods
  # ------------------------------------------------------------

  after_commit -> { broadcast_replace_to 'cart_items', partial: 'site/cart/cart_item', target: 'cart_items', locals: { customer: } }
  after_destroy -> { broadcast_replace_to 'cart_items', partial: 'site/cart/cart_item', target: 'cart_items', locals: { customer: } }

  def market
    customer.market
  end

  # returns a money object of the price
  def price_total(currency)
    Money.from_cents((product.product_price_from_currency(currency).price.cents * quantity), currency)
  end

  private

  def validate_same_markets
    return errors.add(:customer, 'must exist') if customer.nil?
    return errors.add(:product, 'must exist') if product.nil?

    errors.add(:base, 'customer and product must be from the same market') if customer.market != product.market
  end
end
