module Spree
  Taxon.class_eval do
    scope :under_categories, -> { where(taxonomy_id: ::Spree::Taxonomy.categories_taxonomy.id) }
  end
end