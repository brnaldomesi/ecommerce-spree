class AddUserIdToProductsAndStores < ActiveRecord::Migration[5.2]
  def up
    add_column :spree_stores, :user_id, :integer
    add_index :spree_stores, :user_id
    add_column :spree_products, :user_id, :integer
    add_index :spree_products, :user_id
  end

  def down
    remove_column :spree_stores, :user_id
    remove_column :spree_products, :user_id
  end
end
