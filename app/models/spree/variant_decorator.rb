##
# Copied over scopes from spree/product/scopes.rb to collect products by each variant by
# searching over associated products.  Conditions over products are the same except modified
# joins.
module Spree
  Variant.class_eval do
    attr_accessor :has_view_count_changed

    has_many :classifications, through: :product
    belongs_to :user, class_name: 'Spree::User'

    delegate :transaction_count, :txn_count, :engagement_count, :gross_merchandise_sales, :gms, :days_available, :days_listed, to: :product

    #################################
    # Scopes copied from

    scope :ascend_by_updated_at, -> { order(updated_at: :asc) }
    scope :descend_by_updated_at, -> { order(updated_at: :desc) }
    scope :ascend_by_name, -> { order(name: :asc) }
    scope :descend_by_name, -> { order(name: :desc) }

    before_create :set_defaults
    before_update :set_update_attributes
    after_update :update_product


    def self.in_taxon(taxon)
      self.joins(product: [:classifications] ).where('spree_products_taxons.taxon_id' => taxon.self_and_descendants.pluck(:id))
          .select(Spree::Classification.arel_table[:position])
          .order(Spree::Classification.arel_table[:position].asc)
    end

    def self.in_taxons(*taxons)
      taxons = get_taxons(taxons)
      taxons.first ? prepare_taxon_conditions(taxons) : where(nil)
    end

    def self.with_property(property)
      joins(product: [:properties]).where(::Spree::Product.property_conditions(property))
    end

    def self.with_option(option)
      option_types = Spree::OptionType.table_name
      conditions = case option
                     when String     then { "#{option_types}.name" => option }
                     when OptionType then { "#{option_types}.id" => option.id }
                     else { "#{option_types}.id" => option.to_i }
                   end

      joins(product: [:option_types] ).where(conditions)
    end

    def self.with_option_value(option, value)
      option_values = Spree::OptionValue.table_name
      option_type_id = case option
                         when String then Spree::OptionType.find_by(name: option) || option.to_i
                         when Spree::OptionType then option.id
                         else option.to_i
                       end

      conditions = "#{option_values}.name = ? AND #{option_values}.option_type_id = ?", value, option_type_id

      group('spree_variants.id').includes(:option_values).joins(product).where(conditions)
    end

    def self.with(value)
      includes(:option_values).joins(product).
      where("#{Spree::OptionValue.table_name}.name = ? OR #{Spree::ProductProperty.table_name}.value = ?", value, value)
    end

    def self.in_name(words)
      like_any([:name], prepare_words(words))
    end

    def self.in_name_or_keywords(words)
      like_any([:name, :meta_keywords], prepare_words(words))
    end

    def self.in_name_or_description(words)
      like_any([:name, :description, :meta_description, :meta_keywords], prepare_words(words))
    end

    def self.with_ids(ids)
      includes(:product).where("#{::Spree::Product.quoted_table_name}.id IN (?)", ids)
    end

    def self.descend_by_popularity
      joins(:product).
        order(%{
           COALESCE((
             SELECT
               COUNT(#{Spree::LineItem.quoted_table_name}.id)
             FROM
               #{Spree::LineItem.quoted_table_name}
             JOIN
               #{Spree::Variant.quoted_table_name} AS popular_variants
             ON
               popular_variants.id = #{Spree::LineItem.quoted_table_name}.variant_id
             WHERE
               popular_variants.product_id = #{Spree::Product.quoted_table_name}.id
           ), 0) DESC
        })
    end

    def self.not_deleted
      joins(:product).where("#{Spree::Product.quoted_table_name}.deleted_at IS NULL or #{Spree::Product.quoted_table_name}.deleted_at >= ?", Time.current)
    end

    def self.available(available_on = nil)
      where("#{Spree::Product.quoted_table_name}.available_on <= ?", available_on || Time.current)
    end

    def self.taxons_name_eq(name)
      group('spree_products.id').joins(:product[:taxons] ).where(Spree::Taxon.arel_table[:name].eq(name))
    end

    ###########################################
    # Outside update calls

    def update_sorting_rank!
      self.sorting_rank = sprintf('%09d,%010.2f', self.transaction_count * 0.5 * product.view_count, 1000000 - self.price.to_f)
      self.save
      self.sorting_rank
    end

    protected

    def set_update_attributes
      self.has_view_count_changed = true if view_count_changed?
    end

    def update_product
      if has_view_count_changed
        product.recalculate_view_count!
      end
    end

    private

    def set_defaults
      self.user_id ||= product.user_id
    end

    def self.prepare_taxon_conditions(taxons)
      ids = taxons.map { |taxon| taxon.self_and_descendants.pluck(:id) }.flatten.uniq
      joins(:taxons).where("#{Spree::Taxon.table_name}.id" => ids)
    end

    def prepare_words(words)
      return [''] if words.blank?
      a = words.split(/[,\s]/).map(&:strip)
      a.any? ? a : ['']
    end
  end
end