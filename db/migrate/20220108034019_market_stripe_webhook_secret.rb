class MarketStripeWebhookSecret < ActiveRecord::Migration[7.0]
  def change
    add_column :markets, :stripe_webhook_secret, :string
  end
end
