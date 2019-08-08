class SetNilVariantUserId < ActiveRecord::Migration[5.2]
  def change
    Spree::Variant.where('user_id IS NULL').includes(:product).all.each do|v|
      v.update_attributes(user_id: v.product.user_id) unless v.product.user_id.nil?
    end
  end
end
