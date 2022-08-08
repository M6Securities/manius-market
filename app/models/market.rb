# frozen_string_literal: true

class Market < ApplicationRecord
  # Associations
  # ---------------------------------------------------------------------------
  has_many :user_market_permissions, dependent: :destroy
  has_many :users, through: :user_market_permissions
  has_many :products, dependent: :destroy
  has_many :receives, class_name: 'Receive', dependent: :destroy # no idea why this is necessary
  has_many :customers, dependent: :destroy
  has_many :orders, through: :customers
  has_many :action_logs, as: :loggable, dependent: :destroy
  has_many :payment_gateways, dependent: :destroy

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
  validates :email, presence: true,
                    uniqueness: true,
                    email: true,
                    unless: proc { |_m| Rails.env.test? }
end
