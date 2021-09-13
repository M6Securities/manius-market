class AddUserEnabled < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :enabled, :boolean, default: true
  end
end
