class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true, index: true

      t.string :street_1
      t.string :street_2
      t.string :street_3
      t.string :city
      t.string :region
      t.string :postal_area
      t.string :country, limit: 2

      t.string :contact_name
      t.string :contact_phone
      t.integer :address_type, limit: 1 # 1 byte only

      t.timestamps
    end
  end
end
