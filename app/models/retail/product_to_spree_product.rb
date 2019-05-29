module Retail
  class ProductToSpreeProduct < ApplicationRecord
    self.table_name = 'retail_product_to_spree_product'

    belongs_to :retail_product, :class_name => 'Retail::Product'
    belongs_to :spree_product, :class_name => 'Spree::Product', foreign_key: 'spree_product_id', dependent: :destroy
  end
end