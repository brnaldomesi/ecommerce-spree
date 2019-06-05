class AddUserIdToProductVariants < ActiveRecord::Migration[5.2]
  def up
    add_column :spree_variants, :user_id, :integer
    add_index :spree_variants, :user_id
  end

  def down
    remove_column :spree_variants, :user_id
  end
end
