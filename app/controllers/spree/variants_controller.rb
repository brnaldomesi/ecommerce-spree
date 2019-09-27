module Spree
  class VariantsController < Spree::StoreController
    inherit_resources

    before_action :load_taxon, only: :index
    before_action :save_viewer_info, only: [:show]

    helper 'spree/products', 'spree/taxons', 'spree/taxon_filters'

    respond_to :html

    def index
      @searcher = Spree::Core::Search::VariantsSearch.new(params.merge(include_images: true) ).tap do |searcher|
        searcher.current_user = try_spree_current_user
        searcher.pricing_options = current_pricing_options
      end

      @variants = @searcher.retrieve_variants
      logger.debug "| variants#index: searcher #{@searcher}"
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    private

    def accurate_title
      if params[:action] != 'index' && params[:id] && resource.try(:product)
        resource.product.meta_title.blank? ? resource.product.name : resource.product.meta_title
      else
        super
      end
    end

    def load_taxon
      @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
    end

    ##
    # Expect within inherited_resources controller w/ +resource+ available.
    def save_viewer_info
      recent_product_ids = cookies[:recent_product_ids].present? ? JSON.parse( cookies[:recent_product_ids] ) : []
      is_newly_viewed = false
      if spree_current_user
        ::Users::ResourceAction.save_resource_action_for(spree_current_user, resource) do|resource_action|
          logger.info "| #{resource.class}(#{resource.id}) viewed by #{spree_current_user.login}(#{spree_current_user.id}) => #{resource.view_count + 1}"
          is_newly_viewed = true
        end
      else # only use cookies
        unless recent_product_ids.include?(resource.id)
          is_newly_viewed = true
          recent_product_ids << resource.id
          cookies[:recent_product_ids] = recent_product_ids.uniq.to_json
        end
      end

      if is_newly_viewed
        if resource.respond_to?(:view_count)
          resource.update(view_count: resource.view_count.to_i + 1)
        end
      end
    end
  end
end
