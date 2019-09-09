class CreateSiteCategories < ActiveRecord::Migration[5.2]
  def up
    create_table :site_categories do |t|
      t.string  :site_name, null: false
      t.integer :other_site_category_id
      t.integer :mapped_taxon_id
      t.integer :parent_id
      t.integer :position, default: 1
      t.string  :name, limit: 191
      t.integer :lft
      t.integer :rgt
      t.integer :depth, default: 0
      t.timestamps
    end

    add_index :site_categories, :site_name
    add_index :site_categories, [:site_name, :name]
    add_index :site_categories, :parent_id
    add_index :site_categories, :position
    add_index :site_categories, :lft
    add_index :site_categories, :rgt

  end

  def down
    drop_table :site_categories
  end
end
