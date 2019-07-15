class AddSortingRankToVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_variants, :sorting_rank, :string, limit: 32, default: ''
    add_index :spree_variants, :sorting_rank
  end
end
