class RemoveOldAddresses < ActiveRecord::Migration[7.0]
  def change
    # remove address from orders
    remove_column :orders, :address_line_1, :string
    remove_column :orders, :address_line_2, :string
    remove_column :orders, :city, :string
    remove_column :orders, :state, :string
    remove_column :orders, :zip, :string
    remove_column :orders, :country, :string
    remove_column :orders, :shipping_name, :string
  end
end
