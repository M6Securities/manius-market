class Market < ApplicationRecord

  # encrypts :stripe_publishable_key, :stripe_secret_key

  validates_with EmailAddress::ActiveRecordValidator

  has_many :user_market_permissions
  has_many :users, through: :user_market_permissions
  has_many :products

  validates :display_name, presence: true, uniqueness: true

  validates :path_name,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A[a-z]+\z/, # only lowercase letters, no numbers, symbols, or uppercase
              message: "Invalid path name. Make sure it's only lowercase letters. No numbers, symbols, or uppercase characters."
            }

end
