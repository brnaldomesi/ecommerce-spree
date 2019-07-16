module Spree
  Price.class_eval do

    after_save :update_variant

    def update_variant
      variant.update_sorting_rank!
    end
  end
end