module Spree
  class CategoryTaxon < Taxon

    TOP_CATEGORIES_CACHE_KEY = 'Spree::CategoryTaxon.top_categories'

    after_save :clear_cache

    def self.root
      self.where(name: 'Categories', parent_id: nil).last
    end

    ##
    # Find deepest category according to given +full_path+.
    # @return <Spree::Taxon>
    def self.find_by_full_path(full_path)
      levels = full_path.is_a?(Array) ? full_path : full_path.split(' > ')
      taxon = nil
      current_node = root
      levels.each do |cat_name|
        t = current_node.children.where(name: cat_name).first
        if t.nil?
          break
        else
          taxon = t
          current_node = t
        end
      end
      taxon
    end

    def self.find_or_create_categories_taxon()
      taxon = root
      taxon ||= ::Spree::Taxon.find_or_create_by!(taxonomy_id: find_or_create_categories_taxonomy.id) do|t|
        t.position = 0
        t.name = 'Categories'
        t.permalink = 'categories'
        t.depth = 0
      end
      taxon
    end

    def self.find_or_create_categories_taxonomy()
      ::Spree::Taxonomy.find_or_create_by!(name: 'Categories') do|t|
        t.position = 1
      end
    end

    ##
    # Cached top categories.
    def self.top_categories
      Rails.cache.fetch(TOP_CATEGORIES_CACHE_KEY, expires_in: 12.hours) do
        root.children
      end
    end

    protected

    def clear_cache
      Rails.cache.delete(TOP_CATEGORIES_CACHE_KEY)
    end
  end
end