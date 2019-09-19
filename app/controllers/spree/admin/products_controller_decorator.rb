module Spree
  module Admin
    ProductsController.class_eval do

      helper 'spree/admin/navigation'

      before_action :load_master_product, only: [:new]
      before_action :load_variants, only: [:edit, :update]
      before_action :setup_property, only: [:new, :edit], if: -> { can?(:create, model_class) }
      before_action :setup_variant_property_rules, only: [:edit]
      before_action :set_current_user_id, only: [:create, :update, :clone]

      def new
        if @master_product
          @product = @master_product.build_clone
        else
          @product.attributes = permitted_resource_params
        end
        preload_option_types(@product)
        super
      end

      def update
        @product.process_uploaded_images unless @product.changed?
        super
      end

      def erase
        logger.debug "| Erasing product #{@product.id}"
        @product.really_destroy!
        respond_to do|format|
          format.js
          format.html { redirect_to params[:return_url] || request.referer || admin_products_path }
        end
      end

      protected

      def location_after_save
        if updating_variant_property_rules?
          url_params = {}
          url_params[:ovi] = []
          params[:product][:variant_property_rules_attributes].each do |_index, param_attrs|
            # somehow extra params_attrs[:id] pops out w/o the :option_value_ids or that being only String
            url_params[:ovi] += param_attrs[:option_value_ids] if param_attrs[:option_value_ids].is_a?(Array)
          end
        end
        spree.edit_admin_product_path(@product, form: params[:form])
      end

      def permitted_resource_params
        h = params[object_name].present? ? params.require(object_name).permit! : ActionController::Parameters.new.permit!
        h.except(:supplier_ids)
      end

      def load_data
        # skip these unnecessary data
      end

      ##
      # Originally called by Spree::Admin::ImagesController#load_data
      def load_variants
        @product ||= Spree::Product.friendly.find(params[:product_id])
        @variants = @product.variants.collect do |variant|
          [variant.sku_and_options_text, variant.id]
        end
        @variants.insert(0, [t('spree.all'), @product.master.id])
      end

      # From spree/admin/product_properties_controller.rb
      def setup_property
        @product.product_properties.build
      end

      # From spree/admin/product_properties_controller.rb
      def setup_variant_property_rules
        @option_types = @product.variant_option_values_by_option_type
        @option_value_ids = (params[:ovi] || []).reject(&:blank?).map(&:to_i)
        @variant_property_rule = @product.find_variant_property_rule(@option_value_ids) || @product.variant_property_rules.build
        @variant_property_rule.values.build if can?(:create, Spree::VariantPropertyRuleValue)
      end

      def authorize_admin
        if [:show, :edit].include?(action)
          load_resource
          @object.user_id ||= spree_current_user.admin? ?
            spree_current_user.id : Spree::User.admin.first.try(:id)
        end

        super
      end

      def load_master_product
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
        if spree_current_user
          params[:user_id] = spree_current_user.id unless spree_current_user.admin?
        end
        @collection = @collection.where(user_id: params[:user_id] ) if params[:user_id]

        @collection
      end

      ##
      # Requires product initialized
      def preload_option_types(product)
        categories = product.id ? product.categories : []
        if product.taxon_ids.present? && categories.blank?
          categories = ::Spree::Taxon.where(id: product.taxon_ids).all.collect(&:categories_in_path)
        end
        product.option_types = ::Spree::OptionType.default_option_types(categories.to_a.flatten.collect(&:name) )
      end

    end # eval
  end
end