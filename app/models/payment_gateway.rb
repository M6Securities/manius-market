class PaymentGateway < ApplicationRecord
  encrypts :credentials
  belongs_to :market

  validates :gateway, presence: true
  validates :credentials, presence: true
  validates :enabled, inclusion: { in: [true, false] }

  # Gateway Config
  # --------------------------------------------------------------------------------------------------------------------
  # Tells us what fields are required for each gateway, and which gateways we support.
  # All of the theoretical supported gateways are in ActiveMerchant.
  # IMPORTANT: The order of this hash cannot change. The order of this reflects the enum gateway order
  # Should also be reflected in app/javascript/controllers/app/market_space/market/edit_controller.js
  GATEWAY_CONFIG = {
    stripe: %i[publishable_key secret_key]
  }.freeze

  GATEWAY_OPTIONS = GATEWAY_CONFIG.keys.map { |k| [k.to_s.titleize, k] }.freeze

  enum gateway: GATEWAY_CONFIG.keys

  def name
    gateway.to_s.titleize
  end
end
