class CreateUserMarketPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :user_market_permissions do |t|

      t.belongs_to :user
      t.belongs_to :market

      t.string :formatted_permissions, default: ''

      t.timestamps
    end
  end
end
