class OrderShippingName < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :shipping_name, :string
  end
end
