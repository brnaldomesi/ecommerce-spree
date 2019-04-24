module Spree
  module ProductUserRelation

    MANAGEABLE_CLASSES = [
        Spree::ProductOptionType,
        Spree::OptionValue,
        Spree::Price,
        Spree::Product,
        Spree::ProductProperty,
        Spree::Property,
        Spree::Classification,
        # Spree::Taxon,
        Spree::Variant,
        Spree::VariantPropertyRule,
        Spree::ProductPromotionRule,
        Spree::StockItem,
        Spree::StockLocation,
    ]

    def self.included(klass)
      if klass.new.respond_to?(:product)
        klass.delegate :user_id, to: :product
      end
    end
  end
end

::Spree::ProductUserRelation::MANAGEABLE_CLASSES.each do|klass|
  klass.class_eval { include ::Spree::ProductUserRelation }
end