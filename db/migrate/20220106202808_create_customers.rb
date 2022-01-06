class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.belongs_to :user, index: true
      t.belongs_to :market, index: true

      t.timestamps
    end
  end
end
