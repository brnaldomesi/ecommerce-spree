class AddIndexToSpreeTaxonomies < ActiveRecord::Migration[5.2]
  def up
    add_index :spree_taxons, :name unless index_exists?(:spree_taxons, :name)
    add_index :spree_taxonomies, :name unless index_exists?(:spree_taxonomies, :name)
  end

  def down
    drop_index :spree_taxons, :name if index_exists?(:spree_taxons, :name)
    drop_index :spree_taxonomies, :name if index_exists?(:spree_taxonomies, :name)
  end
end
