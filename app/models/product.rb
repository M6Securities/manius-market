class Product < ApplicationRecord
  belongs_to :market

  has_many :receive_items
  has_many :receives, through: :receive_items

  validates :name, presence: true
  validates :price,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0
            }
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


  private

  def unique_sku
    errors.add(:sku, 'sku already exists in this market') unless market.products.where(sku: sku).where.not(id: id).size.zero?
  end

end
