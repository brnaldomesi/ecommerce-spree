module Spree
  Product.class_eval do
    _validators.delete(:slug)
  end
end