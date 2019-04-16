module Spree
  module TaxonsHelper
    # Retrieves the collection of products to display when "previewing" a taxon.  This is abstracted into a helper so
    # that we can use configurations as well as make it easier for end users to override this determination.  One idea is
    # to show the most popular products for a particular taxon (that is an exercise left to the developer.)
    # Notes: this is a patched version as workaround for illegal SQL query in MySQL; the code is nearly the same
    # except the removal of 'select(cols)' calls to query scope.
    def taxon_preview(taxon, max = 4)
      price_scope = Spree::Price.where(current_pricing_options.search_arguments)
      products = taxon.active_products.joins(:prices).select('DISTINCT spree_products.*, spree_products_taxons.position').limit(max)
      if products.size < max # TODO:
        products_arel = Spree::Product.arel_table
        taxon.descendants.each do |descendent_taxon|
          to_get = max - products.length
          products += descendent_taxon.active_products.joins(:prices).merge(price_scope).where(products_arel[:id].not_in(products.map(&:id).uniq)).limit(to_get)
          break if products.size >= max
        end
      end
      products
    end
  end
end
