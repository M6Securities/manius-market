class Market < ApplicationRecord
  validates_with EmailAddress::ActiveRecordValidator

  # Encrypted Attributes
  encrypts :stripe_publishable_key
  encrypts :stripe_secret_key

  # Associations
  # ---------------------------------------------------------------------------
  has_many :user_market_permissions, dependent: :destroy
  has_many :users, through: :user_market_permissions
  has_many :products, dependent: :destroy
  has_many :receives, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :orders, through: :customers

  # Validations
  validates :display_name, presence: true, uniqueness: true
  validates :path_name,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A[a-z]+\z/, # only lowercase letters, no numbers, symbols, or uppercase
              message: "Invalid path name. Make sure it's only lowercase letters. No numbers, symbols, or uppercase characters."
            }
  validates :email, presence: true, uniqueness: true
  validates :stripe_publishable_key, presence: true
  validates :stripe_secret_key, presence: true
end
