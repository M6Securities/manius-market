# frozen_string_literal: true

# easier than working with timezones I'll tell you what
class ProductPrice < ApplicationRecord
  # this makes :price an attribute that returns/updates a Money object
  # https://github.com/RubyMoney/money-rails
  monetize :price_cents

  # Associations
  belongs_to :product

  # validations
  validates_presence_of :product
  validate :unique_currency
  validates :price_cents,
            presence: true,
            numericality: { greater_than: 0 }

  # Callbacks
  after_commit :create_stripe_price, on: :create
  after_commit :update_stripe_price, on: :update

  def market
    product.market
  end

  private

  def unique_currency
    errors.add(:currency, 'must be unique') unless ProductPrice.where(product_id:, price_currency:).where.not(id:).size.zero?
  end

  def create_stripe_price
    CreateStripeProductPriceWorker.perform_async(id)
  end

  def update_stripe_price
    UpdateStripeProductPriceWorker.perform_async(id)
  end
end
