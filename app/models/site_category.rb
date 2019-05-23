##
# Simulate the way Spree::Taxon category hierarchy.  But each site has its own root.
# Attributes: site_name, other_site_category_id, mapped_taxon_id, parent_id, position, name, lft, rgt, depth
class SiteCategory < ApplicationRecord
  acts_as_nested_set

  attr_accessor :is_new

  belongs_to :mapped_taxon, class_name: 'Spree::Taxon'
  scope :mapped, ->{ where('mapped_taxon_id IS NOT NULL') }

  validates :site_name, presence: true
  validates :name, presence: true

  after_save :touch_ancestors_and_taxonomy
  after_touch :touch_ancestors_and_taxonomy

  def self.root_for(site_name)
    self.where(site_name: site_name, parent_id: nil).first || self.create(site_name: site_name, name: site_name + ' categories')
  end

  def self.find_by_full_path(site_name, full_path)
    levels = full_path.is_a?(Array) ? full_path : full_path.split(' > ')
    taxon = nil
    current_node = root_for(site_name)
    levels.each do |cat_name|
      t = current_node.children.where(name: cat_name).first
      if t.nil?
        break
      else
        taxon = t
        current_node = t
      end
    end
    taxon
  end

  ##
  # @return <Array of SiteCategory>
  def self.find_or_create_for(other_site_category, verbose = false)
    taxons = []
    current_node = root_for(other_site_category.site_name)
    other_site_category.full_path.split(' > ').each_with_index do |cat_name, level_index|
      t = current_node.children.where(name: cat_name).first
      spree_taxon = other_site_category.category_id ? other_site_category.category.category_taxon : nil

      if t.nil?
        t = self.create(site_name: other_site_category.site_name,
                        other_site_category_id: other_site_category.other_site_category_id,
                        name: cat_name,
                        mapped_taxon_id: spree_taxon.try(:id))
        t.is_new = true
        t.move_to_child_of(current_node)
      end
      if t.is_new || verbose
        indent = '.' * (level_index * 25)
        puts '%-80s | %60s (%4d) | %s' %
                 [indent + cat_name, spree_taxon.try(:permalink).to_s, spree_taxon.try(:id).to_i, t.is_new ? '***' : '']
      end
      taxons << t
      current_node = t
    end
    taxons
  end

  def self.migrate_from_other_site_categories(verbose = false)
    new_count = 0
    ::Retail::OtherSiteCategory.includes(:category).order('site_name, level asc').each do |other_site_category|
      site_categories = find_or_create_for(other_site_category)
      new_count += 1 if site_categories.find(&:is_new)
    end
    new_count
  end

  private

  def touch_ancestors_and_taxonomy
    # Touches all ancestors at once to avoid recursive taxonomy touch, and reduce queries.
    self.class.where(id: ancestors.pluck(:id)).update_all(updated_at: Time.current)
  end
end