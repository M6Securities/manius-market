class ProductPrice < ApplicationRecord

  monetize :price_cents

  # Associations
  belongs_to :product

  # validations
  validates_presence_of :product
  validate :unique_currency

  def market
    product.market
  end

  private

  def unique_currency
    errors.add(:currency, "must be unique") unless ProductPrice.where(product_id: product_id, price_currency: price_currency).size.zero?
  end

end
