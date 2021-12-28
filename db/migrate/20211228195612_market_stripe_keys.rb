class MarketStripeKeys < ActiveRecord::Migration[7.0]
  def change
    add_column :markets, :stripe_publishable_key, :string
    add_column :markets, :stripe_secret_key, :string
  end
end
