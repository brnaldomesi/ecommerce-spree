module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      @searcher = Spree::Core::Search::VariantsSearch.new(params.merge(include_images: true) ).tap do |searcher|
        searcher.current_user = try_spree_current_user
        searcher.pricing_options = current_pricing_options
      end

      @variants = @searcher.retrieve_variants
      logger.info "| home#index: searcher #{@searcher}"
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end
  end
end
