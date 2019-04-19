# Attributes: name, level, order_index, parent_category_id, full_path,
class Category < RetailScraperRecord
  self.table_name = 'categories'

  belongs_to :parent, class_name:'Category', foreign_key:'parent_category_id', optional: true

  has_many :children, class_name:'Category', foreign_key:'parent_category_id'
  has_many :siblings, -> { where(parent_category_id: parent_category_id) }, class_name:'Category'

  ##
  # Iterate over tree structure of Category records and create Spree::Taxon based on.
  # Instead of recursively going into dynamic sublevels, this goes into furthest 3 levels.
  def self.migrate_to_spree_taxons
    categories_taxon = find_or_create_categories_taxon
    ::Category.where(level: 1).order('order_index asc').each do|top_category|
      top_taxon = categories_taxon.descendants.where(name: top_category.name).last
      unless top_taxon
        top_taxon ||= ::Spree::Taxon.create(
          taxonomy_id: categories_taxon.taxonomy_id, position: top_category.order_index,
          name: top_category.name,
          permalink: 'categories/' + convert_name_to_link_value(top_category.name) )
        top_taxon.move_to_child_of( categories_taxon )
      end
      puts '%30s' % [top_taxon.name]
      top_category.children.order('order_index asc').each do|second_cat|
        second_taxon = top_taxon.descendants.where(name: second_cat.name).last
        unless second_taxon
          second_taxon ||= ::Spree::Taxon.create(
              taxonomy_id: categories_taxon.taxonomy_id, position: second_cat.order_index,
              name: second_cat.name,
              permalink: top_taxon.permalink + '/' + convert_name_to_link_value(second_cat.name) )
          second_taxon.move_to_child_of( top_taxon )
        end
        puts '%30s \\ %20s' % ['', second_taxon.name]
        second_cat.children.order('order_index asc').each do|third_cat|
          third_taxon = second_taxon.descendants.where(name: third_cat.name).last
          unless third_taxon
            third_taxon ||= ::Spree::Taxon.create(
                taxonomy_id: categories_taxon.taxonomy_id, position: third_cat.order_index,
                name: third_cat.name,
                permalink: second_taxon.permalink + '/' + convert_name_to_link_value(third_cat.name) )
            third_taxon.move_to_child_of( second_taxon )
          end
          puts '%30s \\ %20s \\ %s' % ['', '', third_taxon.name]
        end
      end
    end
    ### categories_taxon.rebuild!
  end

  def self.convert_name_to_link_value(name)
    name.squish.gsub(/([^a-z\s\d]+)/i, '').gsub(/(\s+)/, '-').downcase
  end

  def self.find_or_create_categories_taxon()
    taxon = ::Spree::Taxon.where(name: 'Categories', parent_id: nil).last
    taxon ||= ::Spree::Taxon.find_or_create_by!(taxonomy_id: find_or_create_categories_taxonomy.id) do|t|
      t.position = 0
      t.name = 'Categories'
      t.permalink = 'categories'
      t.depth = 0
    end
    taxon
  end

  def self.find_or_create_categories_taxonomy()
    ::Spree::Taxonomy.find_or_create_by!(name: 'Categories') do|t|
      t.position = 1
    end
  end

end