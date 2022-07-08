class MarketDefaultCurrency < ActiveRecord::Migration[7.0]
  def change
    add_column :markets, :default_currency, :string, default: 'USD'
  end
end
