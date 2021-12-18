class CreateMarkets < ActiveRecord::Migration[7.0]
  def change
    create_table :markets do |t|

      t.string :display_name, default: ''
      t.string :path_name, default: ''

      t.string :email, default: ''

      t.timestamps
    end
  end
end
