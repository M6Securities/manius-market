class RemoveStripe < ActiveRecord::Migration[7.0]
  def change
    # remove_index :products, :index_products_on_stripe_product_id
    remove_column :products, :stripe_product_id

    remove_column :product_prices, :stripe_price_id

    remove_column :customers, :stripe_customer_id

    remove_column :markets, :stripe_publishable_key
    remove_column :markets, :stripe_secret_key
    remove_column :markets, :stripe_webhook_secret

    remove_column :order_items, :stripe_line_item_id

    remove_column :orders, :stripe_checkout_session_id
    remove_column :orders, :stripe_payment_intent_id
  end
end
