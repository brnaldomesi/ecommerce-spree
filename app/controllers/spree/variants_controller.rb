module Spree
  class VariantsController < Spree::StoreController
    inherit_resources

    before_action :load_taxon, only: :index

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
      if resource.try(:product)
        resource.product.meta_title.blank? ? resource.product.name : resource.product.meta_title
      else
        super
      end
    end

    def load_taxon
      @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
    end
  end
end
