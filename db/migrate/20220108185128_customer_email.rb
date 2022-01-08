class CustomerEmail < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :email, :string
  end
end
