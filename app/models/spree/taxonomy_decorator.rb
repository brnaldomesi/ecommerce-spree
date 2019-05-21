module Spree
  Taxonomy.class_eval do
    def self.categories_taxonomy
      @@categories_taxonomy ||= self.where(name: 'Categories').first
    end
  end
end