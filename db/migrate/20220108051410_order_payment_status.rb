class OrderPaymentStatus < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :payment_status, :integer, default: Order::PS_NONE
  end
end
