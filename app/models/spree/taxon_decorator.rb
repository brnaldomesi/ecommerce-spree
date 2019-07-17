module Spree
  Taxon.class_eval do
    scope :under_categories, -> { where(taxonomy_id: ::Spree::Taxonomy.categories_taxonomy.id) }

    def breadcrumb
      list = []
      categories_in_path do|current_node|
        list.insert(0, current_node.name)
      end
      list.join(' > ')
    end

    ##
    # Reverse back to just before Categories root, meaning the top categories.
    # @return <Array of Spree::Taxon>
    def categories_in_path(&block)
      list = []
      current_node = self
      while current_node && current_node.name != 'Categories'
        yield current_node if block_given?
        list.insert(0, current_node)
        current_node = current_node.parent
      end
      list
    end
  end
end