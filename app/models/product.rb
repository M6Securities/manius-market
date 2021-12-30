class Product < ApplicationRecord

  # Associations
  # ------------------------------------------------------------
  belongs_to :market

  has_many :receive_items
  has_many :receives, through: :receive_items
  has_many :product_prices, dependent: :destroy

  after_commit :create_stripe_product, on: :create
  after_commit :update_stripe_product, on: :update

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

  def stripe_product_id
    # stripe product ids are not globally unique, so we need to make it unique for us
    "maniusmarket_#{market.path_name}_#{id}"
  end


  private

  def unique_sku
    errors.add(:sku, 'sku already exists in this market') unless market.products.where(sku: sku).where.not(id: id).size.zero?
  end

  def create_stripe_product
    CreateStripeProductWorker.perform_async(id)
  end

  def update_stripe_product
    UpdateStripeProductWorker.perform_async(id)
  end

end
