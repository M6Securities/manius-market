# frozen_string_literal: true

# Primary product object
class Product < ApplicationRecord
  # Attachments
  # ------------------------------------------------------------
  has_one_attached :primary_image

  # Associations
  # ------------------------------------------------------------
  belongs_to :market

  has_many :receive_items
  has_many :receive, through: :receive_items, as: :receives

  has_many :product_prices, dependent: :destroy

  has_many :cart_items, dependent: :destroy
  has_many :customers, through: :cart_items

  has_many :order_items
  has_many :orders, through: :order_items

  has_many :action_logs, as: :loggable, dependent: :destroy

  # Validations
  # ------------------------------------------------------------
  validates :name, presence: true
  validates :sku,
            presence: true,
            format: {
              with: /\A[A-Z0-9]+\z/, # only lowercase letters, no numbers, symbols, or uppercase
              message: "Invalid sku. Make sure it's only uppercase alphanumeric characters. No symbols or lowercase characters."
            }
  validates :stock,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }
  validate :unique_sku
  validates :enabled, inclusion: { in: [true, false] }
  validates :shippable, inclusion: { in: [true, false] }
  validates :description, presence: true

  # Methods
  # ------------------------------------------------------------

  def primary_image_icon_url
    if primary_image.variable?
      url_for(product.primary_image.variant(gravity: 'Center', resize: '200x200^', crop: '200x200+0+0'))
    else
      'https://cdn.m6securities.com/vuexy_admin_8-0/app-assets/images/icons/unknown.png'
    end
  end

  def product_price_from_currency(currency_code)
    product_prices.find_by(price_currency: currency_code)
  end

  private

  def unique_sku
    errors.add(:sku, 'sku already exists in this market') unless market.products.where(sku:).where.not(id:).size.zero?
  end
end
