class AddUsernameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_users, :username, :string, limit: 64
    add_index :spree_users, :username, unique: true
    add_column :spree_users, :display_name, :string, limit: 64
  end
end
