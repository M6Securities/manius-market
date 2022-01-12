class OrderStatus < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :status, :integer, default: Order::OS_NOT_ACKNOWLEDGED

    add_index :orders, :status
  end
end
