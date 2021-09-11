class CreateMarkets < ActiveRecord::Migration[6.1]
  def change
    create_table :markets do |t|

      t.string :display_name, default: ''
      t.string :path_name, default: ''

      t.string :stripe_publishable_key_ciphertext
      t.string :stripe_secret_key_ciphertext

      t.string :email, default: ''

      t.timestamps
    end
  end
end
