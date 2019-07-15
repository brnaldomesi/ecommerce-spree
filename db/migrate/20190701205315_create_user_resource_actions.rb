class CreateUserResourceActions < ActiveRecord::Migration[5.2]
  def up
    add_column :spree_products, :view_count, :integer, default: 0
    add_column :spree_variants, :view_count, :integer, default: 0

    create_table :users_resource_actions do |t|
      t.integer :user_id, nil: false
      t.string  :resource_type, nil: false, limit: 64
      t.integer :resource_id, nil: false
      t.string  :action, default: 'VIEW'
      t.timestamps
    end
    add_index :users_resource_actions, [:user_id, :action]
    add_index :users_resource_actions, [:resource_type, :resource_id]
    add_index :users_resource_actions, [:user_id, :created_at]
  end

  def down
    remove_column :spree_products, :view_count
    remove_column :spree_variants, :view_count
    drop_table :users_resource_actions
  end
end
