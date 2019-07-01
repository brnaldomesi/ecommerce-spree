module Spree
  ProductDuplicator.class_eval do
    ##
    # Changed version of Spree::ProductDuplicator#duplicate w/o saving files.
    def build_clone(&block)
      draft = product.dup.tap do |new_product|
        new_product.taxons = product.taxons
        new_product.created_at = nil
        new_product.deleted_at = nil
        new_product.updated_at = nil
        new_product.product_properties = reset_properties
        # new_product.master = duplicate_master
        new_product.price = product.price
        new_product.sku = "COPY OF #{product.sku}" if product.sku.present? && !product.sku.start_with?('COPY OF ')
      end
      draft.option_types = product.option_types
      draft.master_product_id = product.id
      yield draft if block_given?
      draft
    end

  end
end