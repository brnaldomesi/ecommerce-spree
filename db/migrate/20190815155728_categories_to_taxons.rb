class CategoriesToTaxons < ActiveRecord::Migration[5.2]
  def change
    ::Category.migrate_to_spree_taxons
  end
end
