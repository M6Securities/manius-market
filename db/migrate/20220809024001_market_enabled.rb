class MarketEnabled < ActiveRecord::Migration[7.0]
  def change
    add_column :markets, :enabled, :boolean, default: false
  end
end
