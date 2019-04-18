module Spree
  class CategoryTaxon < Taxon

    TOP_CATEGORIES_CACHE_KEY = 'Spree::CategoryTaxon.top_categories'

    after_save :clear_cache

    ##
    # Cached top categories.
    def self.top_categories
      Rails.cache.fetch(TOP_CATEGORIES_CACHE_KEY, expires_in: 12.hours) do
        self.where(name: 'Categories').root.children
      end
    end

    protected

    def clear_cache
      Rails.cache.delete(TOP_CATEGORIES_CACHE_KEY)
    end
  end
end