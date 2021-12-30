class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products, id: :uuid do |t|

      t.string :name, default: ''
      t.string :sku, default: ''
      t.decimal :price, precision: 8, scale: 2, default: 0
      t.integer :stock, default: 0
      t.string :tax_code, default: ''

      t.belongs_to :market

      t.index :sku

      t.timestamps
    end
  end
end
