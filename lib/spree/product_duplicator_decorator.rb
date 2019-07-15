##
# Modified version that changes methods like build_clone.
module Spree
  ProductDuplicator.class_eval do
    ##
    # Changed version of Spree::ProductDuplicator#duplicate w/o saving files.
    # The returned draft will inherit product's master_product_id if exists.
    def build_clone(&block)
      draft = product.dup.tap do |new_product|
        new_product.taxons = product.taxons
        new_product.created_at = nil
        new_product.deleted_at = nil
        new_product.updated_at = nil
        new_product.product_properties = reset_properties
        # new_product.master = duplicate_master
        new_product.price = product.price
        new_product.sku = '' # "COPY OF #{product.sku}" if product.sku.present? && !product.sku.start_with?('COPY OF ')
      end
      draft.option_types = product.option_types
      draft.master_product_id = product.master_product_id || product.id
      draft.find_or_build_master

      yield draft if block_given?
      draft
    end

  end
end