class ActionLog < ApplicationRecord
  # Associations
  # --------------------------------------------------------------------------------------------------------------------

  belongs_to :loggable, polymorphic: true

  belongs_to :user_market_permission
  belongs_to :user, through: :user_market_permission

  # Validations
  # --------------------------------------------------------------------------------------------------------------------

  validates :user_market_permission, presence: true
  validates :loggable, presence: true
  validates :action, presence: true
end
