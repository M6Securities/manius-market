class CreateActionLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :action_logs do |t|
      t.references :loggable, polymorphic: true, index: true

      t.string :action, default: '', null: false
      t.belongs_to :user_market_permission, index: true

      t.timestamps
    end
  end
end
