class AddDeviseSecurity < ActiveRecord::Migration[6.1]
  def change
    # Password expirable
    add_column :users, :password_changed_at, :datetime
    add_index :users, :password_changed_at

    # Password archivable
    create_table :old_passwords do |t|
      t.string :encrypted_password, null: false
      t.string :password_archivable_type, null: false
      t.integer :password_archivable_id, null: false
      t.string :password_salt # Optional. bcrypt stores the salt in the encrypted password field so this column may not be necessary.
      t.datetime :created_at
    end
    add_index :old_passwords, [:password_archivable_type, :password_archivable_id], name: 'index_password_archivable'

    # Expirable
    add_column :users, :last_activity_at, :datetime
    add_column :users, :expired_at, :datetime
    add_index :users, :last_activity_at
    add_index :users, :expired_at

    # Session limitable
    add_column :users, :unique_session_id, :string
  end
end
