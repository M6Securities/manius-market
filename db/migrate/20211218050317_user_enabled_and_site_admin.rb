class UserEnabledAndSiteAdmin < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :enabled, :boolean, default: true
    add_column :users, :site_admin, :boolean, default: false
  end
end
