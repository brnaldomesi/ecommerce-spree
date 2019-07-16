module Spree
  module Core
    module Search
      class VariantsSearch < Base

        def retrieve_variants
          @variants = get_base_scope
          cur_page = @properties[:page] || 1

          unless Spree::Config.show_products_without_price
            @variants = @variants.joins(:prices).merge(Spree::Price.where(pricing_options.search_arguments)).distinct
          end
          @variants = @variants.page(cur_page).per(@properties[:per_page])
        end

        def to_s
          "VariantsSearch (#{@properties})"
        end

        protected

        def get_base_scope
          base_scope = Spree::Variant.includes(:product).where(nil)
          base_scope = base_scope.in_taxon(@properties[:taxon]) unless @properties[:taxon].blank?
          base_scope = get_conditions_for(base_scope, @properties[:keywords])
          base_scope = add_search_scopes(base_scope)
          base_scope = add_eagerload_scopes(base_scope)
          base_scope = add_sort_scopes(base_scope)
          base_scope
        end

        def add_eagerload_scopes(scope)
          scope = scope.preload(:currently_valid_prices, :images)
          scope = scope.preload(:product) if @properties[:include_images]
          scope
        end

        def add_search_scopes(base_scope)
          if @properties[:search]
            @properties[:search].each do |name, scope_attribute|
              scope_name = name.to_sym
              if base_scope.respond_to?(:search_scopes) && base_scope.search_scopes.include?(scope_name.to_sym)
                base_scope = base_scope.send(scope_name, *scope_attribute)
              else
                base_scope = base_scope.merge(Spree::Product.ransack({ scope_name => scope_attribute }).result)
              end
            end
          end
          base_scope
        end

        def add_sort_scopes(base_scope)
          sort = @properties[:s] || @properties[:sort]
          sort = 'sorting_rank desc' if sort.blank?
          sort = convert_sort_order(sort)
          sort_field = sort.split(' ')[0]
          base_scope.joins(:product).select("#{Spree::Variant.table_name}.*, #{sort_field} AS sort_field").order(sort.gsub(sort_field, 'sort_field') )
        end

        SORT_ORDER_ALIASES = {
            'gms' => "#{Spree::Product.table_name}.gross_merchandise_sales"
          }
        ##
        # Some order attribute might be short alias.
        def convert_sort_order(order)
          return nil if order.blank?
          o = order.clone
          SORT_ORDER_ALIASES.each_pair do|value_alias, real_value|
            o.gsub!(value_alias, real_value)
          end
          o
        end

        # method should return new scope based on base_scope
        def get_conditions_for(base_scope, query)
          unless query.blank?
            base_scope = base_scope.like_any([:name, :description], query.split)
          end
          base_scope
        end

        def prepare(params)
          @properties[:taxon] = params[:taxon].blank? ? nil : Spree::Taxon.find(params[:taxon])
          @properties[:keywords] = params[:keywords]
          @properties[:search] = params[:search]
          @properties[:include_images] = params[:include_images]

          per_page = params[:per_page].to_i
          @properties[:per_page] = per_page > 0 ? per_page : 24
          @properties[:page] = (params[:page].to_i <= 0) ? 1 : params[:page].to_i
        end
      end
    end
  end
end
