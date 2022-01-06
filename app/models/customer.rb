class Customer < ApplicationRecord
  # Associations
  # ------------------------------------------------------------
  belongs_to :user, optional: true
  belongs_to :market, optional: false

  has_many :cart_items, dependent: :destroy

  # Validations
  # ------------------------------------------------------------
  validates_presence_of :market
end
