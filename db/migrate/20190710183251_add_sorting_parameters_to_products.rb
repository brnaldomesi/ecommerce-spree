class AddSortingParametersToProducts < ActiveRecord::Migration[5.2]
  def up
    add_column :spree_users, :non_paying_buyer_count, :integer, default: 0

    add_column :spree_products, :transaction_count, :integer, default: 0
    add_column :spree_products, :engagement_count, :integer, default: 0
    add_column :spree_products, :gross_merchandise_sales, :float, default: 0.0

    add_column :spree_variants, :incomplete_transaction_count, :integer, default: 0
  end

  def down
    remove_column :spree_users, :non_paying_buyer_count

    remove_column :spree_products, :gross_merchandise_sales
    remove_column :spree_products, :transaction_count
    remove_column :spree_products, :engagement_count

    remove_column :spree_variants, :incomplete_transaction_count
  end
end
