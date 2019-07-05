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
      logger.info "| variants#index: searcher #{@searcher}"
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
      recent_product_ids = session[:recent_product_ids] ||
      if spree_current_user
        ::Users::ResourceAction.save_view_count_for(spree_current_user, resource)
      else # only use cookies
      end
    end
  end
end
