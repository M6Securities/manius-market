class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders, id: :uuid do |t|
      t.belongs_to :customer, index: true, type: :uuid

      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country

      t.string :stripe_checkout_session_id

      t.timestamps
    end
  end
end
