##
# Copied over codes and patched from original source.  If version updated, do change accordingly.
module Spree
  class TaxonsController < Spree::StoreController

    before_action :load_taxon, only: [:show]

    def show
      @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)

      respond_to do|format|
        format.html { render 'spree/taxons/show_customized' }
      end
    end

    def show_customized
      @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
      @products = @searcher.retrieve_products
      logger.info "| products #{@products.class}: #{@products.to_a}"
      logger.info "|   count =  #{@products.count}, empty? #{@products.empty?}"
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    private

    def load_taxon
      @taxon = Spree::Taxon.find_by!(permalink: params[:id])
    end

    def accurate_title
      if @taxon
        @taxon.seo_title
      else
        super
      end
    end
  end
end
