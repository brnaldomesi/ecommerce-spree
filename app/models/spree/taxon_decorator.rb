module Spree
  Taxon.class_eval do
    scope :under_categories, -> { where(taxonomy_id: ::Spree::Taxonomy.categories_taxonomy.id) }

    def breadcrumb
      list = []
      current_node = self
      while current_node && current_node.name != 'Categories'
        list.insert(0, current_node.name)
        current_node = current_node.parent
      end
      list.join(' > ')
    end
  end
end