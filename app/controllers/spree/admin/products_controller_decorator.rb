module Spree
  module Admin
    ProductsController.class_eval do
      before_action :set_current_user_id, only: [:create, :update, :clone]

      def set_current_user_id
        @object.user_id ||= spree_current_user.try(:id) if @object
        @new.user_id = spree_current_user.try(:id) if @new
      end

      ##
      # Copied over code and then added w/ extra current user only condition.
      def collection
        return @collection if @collection
        params[:q] ||= {}
        params[:q][:s] ||= 'name asc'
        logger.info "| spree_roles #{spree_current_user.spree_roles.collect(&:name)}, admin? #{spree_current_user.admin?}"
        # @search needs to be defined as this is passed to search_form_for
        @search = super.ransack(params[:q])
        @collection = @search.result.
            order(id: :asc).
            includes(product_includes).
            page(params[:page]).
            per(Spree::Config[:admin_products_per_page])
        @collection = @collection.where(user_id: spree_current_user.try(:id) ) if spree_current_user && !spree_current_user.admin?
        @collection
      end

    end # eval
  end
end