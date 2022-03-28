# Holds 1 record. Stores and validates global app settings
class Setting < ApplicationRecord
  # Constants
  # --------------------------------------------------------------------------------------------------------------------
  KEYS = %i[
    app_name
    allow_registration
    allow_market_creation
  ].freeze

  BOOLEAN_KEYS = %i[
    allow_registration
    allow_market_creation
  ].freeze

  # Validations
  # --------------------------------------------------------------------------------------------------------------------

  validate :there_can_only_be_one

  validates :app_name, presence: true
  validates :allow_registration, inclusion: { in: [true, false] }
  validates :allow_market_creation, inclusion: { in: [true, false] }

  private

  def there_can_only_be_one
    errors.add(:id, 'a setting record already exists') unless Setting.all.size <= 1
  end
end
