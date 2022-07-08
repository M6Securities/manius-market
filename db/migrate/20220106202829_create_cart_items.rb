class CreateCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_items, id: :uuid do |t|
      t.belongs_to :product, index: true, type: :uuid
      t.belongs_to :customer, index: true, type: :uuid

      t.integer :quantity, default: 0

      t.timestamps
    end
  end
end
