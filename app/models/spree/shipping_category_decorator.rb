module Spree
  ShippingCategory.class_eval do
    def self.default
      self.last || self.create(name: 'Default')
    end
  end
end