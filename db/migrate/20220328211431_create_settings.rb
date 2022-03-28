class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.string :app_name, default: 'Manius Market'
      t.boolean :allow_registration, default: true
      t.boolean :allow_market_creation, default: true

      t.timestamps
    end
  end
end
