module Spree
  Taxonomy.class_eval do
    def self.categories_taxonomy
      @@categories_taxonomy ||= ::Category.find_or_create_categories_taxonomy
    end
  end
end