module Spree
  module Admin
    ProductsController.class_eval do
      before_action :load_master_product, only: [:new]
      before_action :set_current_user_id, only: [:create, :update, :clone]

      def new
        if @master_product
          @product = @master_product.build_clone
        else
          @product.attributes = permitted_resource_params
        end
        @product.option_types = ::Spree::OptionType.default_option_types
        super
      end

      protected

      def permitted_resource_params
        h = params[object_name].present? ? params.require(object_name).permit! : ActionController::Parameters.new.permit!
        h.except(:supplier_ids)
      end

      def authorize_admin
        logger.info "| current action: #{action}"
        if [:show, :edit].include?(action)
          load_resource
          @object.user_id ||= spree_current_user.admin? ?
            spree_current_user.id : Spree::User.admin.first.try(:id)
        end

        super
      end

      def load_master_product
        logger.info "| params #{params}"
        logger.info "| present? #{params[object_name].present?}"
        @master_product = ::Spree::Product.where(id: permitted_resource_params[:master_product_id]).first if permitted_resource_params[:master_product_id]
      end

      def set_current_user_id
        @object.user_id ||= spree_current_user.try(:id) if @object && !spree_current_user.admin?
        @new.user_id = spree_current_user.try(:id) if @new
      end

      ##
      # Copied over code and then added w/ extra current user only condition.
      def collection
        return @collection if @collection
        params[:q] ||= {}
        params[:q][:s] ||= 'id asc'
        logger.info "| spree_roles #{spree_current_user ? spree_current_user.spree_roles.collect(&:name) : ' no-user '}, admin? #{spree_current_user.try(:admin?) }"
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