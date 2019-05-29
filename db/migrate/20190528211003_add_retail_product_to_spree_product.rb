class AddRetailProductToSpreeProduct < ActiveRecord::Migration[5.2]
  def up
    create_table :retail_product_to_spree_product do|t|
      t.integer :retail_product_id
      t.integer :spree_product_id
      t.timestamps
    end
    add_index :retail_product_to_spree_product, :retail_product_id
  end

  def down
    drop_table :retail_product_to_spree_product
  end
end
