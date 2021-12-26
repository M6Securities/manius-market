class CreateReceiveItems < ActiveRecord::Migration[7.0]
  def change
    create_table :receive_items, id: :uuid do |t|

      t.belongs_to :receive, type: :uuid
      t.belongs_to :product

      t.integer :quantity, default: 0

      t.timestamps
    end
  end
end
