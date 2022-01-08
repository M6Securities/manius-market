class OrderCustomerStripeDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :stripe_customer_id, :string, index: true
    add_column :orders, :stripe_payment_intent_id, :string, index: true
  end
end
