class CreatePaymentGateways < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_gateways do |t|
      t.integer :gateway, null: false
      t.boolean :enabled, default: true
      t.jsonb :credentials, default: {}, null: false
      t.belongs_to :market

      t.timestamps
    end
  end
end
