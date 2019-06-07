# frozen_string_literal: true

module Spree
  class ProductsController < Spree::StoreController
    before_action :load_product, only: :show
    before_action :load_taxon, only: :index

    helper 'spree/taxons', 'spree/taxon_filters'

    respond_to :html

    def index
      @searcher = Spree::Core::Search::Base.new(params.merge(include_images: true) ).tap do |searcher|
        searcher.current_user = try_spree_current_user
        searcher.pricing_options = current_pricing_options
      end

      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    def show
      @variants = @product.
          variants_including_master.
          display_includes.
          with_prices(current_pricing_options).
          includes([:option_values, :images])

      @product_properties = @product.product_properties.includes(:property)
      @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
    end

    private

    def accurate_title
      if @product
        @product.meta_title.blank? ? @product.name : @product.meta_title
      else
        super
      end
    end

    def load_product
      if try_spree_current_user.try(:has_spree_role?, "admin")
        @products = Spree::Product.with_deleted
      else
        @products = Spree::Product.available
      end
      @product = @products.friendly.find(params[:id])
    end

    def load_taxon
      @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
    end
  end
end