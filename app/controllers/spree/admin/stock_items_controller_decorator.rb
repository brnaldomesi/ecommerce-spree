module Spree
  module Admin
    StockItemsController.class_eval do

      def load_stock_management_data
        @stock_locations = Spree::StockLocation.accessible_by(current_ability, :read)
        @stock_item_stock_locations = params[:stock_location_id].present? ? @stock_locations.where(id: params[:stock_location_id]) : @stock_locations
        @variant_display_attributes = self.class.variant_display_attributes
        @variants = Spree::Config.variant_search_class.new(params[:variant_search_term], scope: variant_scope).results
        @variants = @variants.includes(:images, :product, stock_items: :stock_location, product: :variant_images)
        @variants = @variants.includes(option_values: :option_type)
        @variants = @variants.order(id: :desc).page(params[:page]).per(params[:per_page] || Spree::Config[:orders_per_page])
        @variants = @variants.joins(:product).where("#{Spree::Product.table_name}.user_id=?", spree_current_user.try(:id) ) if spree_current_user && !spree_current_user.admin?
      end

    end
  end
end