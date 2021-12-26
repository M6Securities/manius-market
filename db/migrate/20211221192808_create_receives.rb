class CreateReceives < ActiveRecord::Migration[7.0]
  def change
    create_table :receives, id: :uuid do |t|

      t.belongs_to :market
      t.belongs_to :user

      t.timestamps
    end
  end
end
