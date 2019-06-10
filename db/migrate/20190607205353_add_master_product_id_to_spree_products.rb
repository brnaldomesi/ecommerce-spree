class AddMasterProductIdToSpreeProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :master_product_id, :integer
    add_index :spree_products, :master_product_id
  end
end
