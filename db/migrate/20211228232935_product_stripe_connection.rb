class ProductStripeConnection < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :stripe_id, :string
    add_column :products, :enabled, :boolean, default: true

    # product shippable
    add_column :products, :shippable, :boolean, default: true

    # product description
    add_column :products, :description, :string, default: ''

    add_index :products, :stripe_id, unique: true

    change_column_default :products, :tax_code, 'txcd_99999999' # general tax code; https://stripe.com/docs/tax/tax-codes
  end
end
