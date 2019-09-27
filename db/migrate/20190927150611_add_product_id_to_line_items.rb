class AddProductIdToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_line_items, :product_id, :integer
    add_index :spree_line_items, :product_id

    ::Spree::LineItem.all.each do|line_item|
      line_item.update(product_id: line_item.variant.product_id)
    end
  end
end
