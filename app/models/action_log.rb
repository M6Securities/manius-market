# frozen_string_literal: true

# Stores actions taken on models
class ActionLog < ApplicationRecord
  # Associations
  # --------------------------------------------------------------------------------------------------------------------

  belongs_to :loggable, polymorphic: true

  belongs_to :user_market_permission

  # Validations
  # --------------------------------------------------------------------------------------------------------------------

  validates :user_market_permission, presence: true
  validates :loggable, presence: true
  validates :action, presence: true

  # Methods
  # --------------------------------------------------------------------------------------------------------------------

  def user
    user_market_permission.user
  end
end
