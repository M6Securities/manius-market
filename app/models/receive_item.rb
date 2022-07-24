class ReceiveItem < ApplicationRecord
  # Associations
  # ------------------------------------------------------------------------------------------------------
  belongs_to :receive
  belongs_to :product

  # Validations
  # ------------------------------------------------------------------------------------------------------
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  def user
    receive.user
  end
end
