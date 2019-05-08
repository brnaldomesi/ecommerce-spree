class AddTimezoneAndCountryToSpree < ActiveRecord::Migration[5.2]
  def up
    add_column :spree_users, :country, :string, limit: 64
    add_column :spree_users, :country_code, :string, limit: 16
    add_column :spree_users, :zipcode, :string, limit: 64
    add_column :spree_users, :timezone, :string, limit: 64
  end

  def down
    remove_column :spree_users, :country
    remove_column :spree_users, :country_code
    remove_column :spree_users, :zipcode
    remove_column :spree_users, :timezone
  end
end
