class OrderLineItemId < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :stripe_line_item_id, :string
  end
end
