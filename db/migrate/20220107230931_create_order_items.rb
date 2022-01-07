class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.belongs_to :order, type: :uuid, index: true
      t.belongs_to :product, type: :uuid, index: true

      t.integer :quantity, default: 0

      t.timestamps
    end
  end
end
