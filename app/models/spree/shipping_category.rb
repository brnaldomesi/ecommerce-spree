module Spree
  class ShippingCategory < Spree::Base
    def self.default
      self.last || self.create(name: 'Default')
    end
  end
end