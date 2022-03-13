class OrderTotalPrice < ActiveRecord::Migration[7.0]
  def change
    add_monetize :orders, :total_price, amount: { null: true, default: nil }, currency: { null: true, default: nil }
  end
end
