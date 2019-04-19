module Spree
  module ProductRelation
    extend ActiveSupport::Concern

    def self.included(klass)
      klass.belongs_to :user, optional: true
    end
  end
end

::Spree::Product.class_eval { include ::Spree::ProductRelation }