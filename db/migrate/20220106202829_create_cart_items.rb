class CreateCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_items do |t|
      t.belongs_to :product, index: true
      t.belongs_to :customer, index: true

      t.integer :quantity, default: 0

      t.timestamps
    end
  end
end
