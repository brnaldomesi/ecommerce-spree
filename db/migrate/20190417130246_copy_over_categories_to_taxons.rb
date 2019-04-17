class CopyOverCategoriesToTaxons < ActiveRecord::Migration[5.2]
  def change
    ::Category.migrate_to_spree_taxons
    ::Spree::Taxon.rebuild!
  end
end
