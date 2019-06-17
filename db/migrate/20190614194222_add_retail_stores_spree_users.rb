class AddRetailStoresSpreeUsers < ActiveRecord::Migration[5.2]
  def up
    create_table :retail_stores_spree_users do|t|
      t.integer :retail_store_id
      t.integer :spree_user_id
    end
    add_index :retail_stores_spree_users, :retail_store_id
  end

  def down
    drop_table :retail_stores_spree_users
  end
end
