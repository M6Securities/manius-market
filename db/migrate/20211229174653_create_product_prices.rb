class CreateProductPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :product_prices do |t|
      t.belongs_to :product, index: true

      t.monetize :price
      t.string :stripe_price_id

      t.timestamps
    end

    remove_column :products, :price, :decimal
  end
end
