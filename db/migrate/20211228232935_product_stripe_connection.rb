class ProductStripeConnection < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :stripe_id, :string
    add_column :products, :enabled, :boolean, default: true

    # product shippable
    add_column :products, :shippable, :boolean, default: true

    # product description
    add_column :products, :description, :string, default: ''
  end
end
