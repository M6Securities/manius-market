# frozen_string_literal: true

class Market < ApplicationRecord
  # Encrypted Attributes
  encrypts :stripe_publishable_key
  encrypts :stripe_secret_key
  encrypts :stripe_webhook_secret

  # Associations
  # ---------------------------------------------------------------------------
  has_many :user_market_permissions, dependent: :destroy
  has_many :users, through: :user_market_permissions
  has_many :products, dependent: :destroy
  has_many :receives, class_name: 'Receive', dependent: :destroy # no idea why this is necessary
  has_many :customers, dependent: :destroy
  has_many :orders, through: :customers
  has_many :action_logs, as: :loggable, dependent: :destroy

  # Validations
  # ---------------------------------------------------------------------------
  validates :display_name, presence: true, uniqueness: true
  validates :path_name,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A[a-z]+\z/, # only lowercase letters, no numbers, symbols, or uppercase
              message: "Invalid path name. Make sure it's only lowercase letters. No numbers, symbols, or uppercase characters."
            }
  validates :email, presence: true, uniqueness: true, email: true, if: !Rails.env.test?
  validates :stripe_publishable_key, presence: true
  validates :stripe_secret_key, presence: true
  validates :stripe_webhook_secret, presence: true
end
