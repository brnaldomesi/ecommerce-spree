##
# Attributes: site_name, name, other_site_category_id, level, order_index, parent_category_id, full_path, category_id
class OtherSiteCategory < RetailScraperRecord

  attr_accessor :newly_created

  belongs_to :category, optional: true
  belongs_to :parent, class_name:'OtherSiteCategory', foreign_key:'parent_category_id', optional: true

  has_many :children, class_name:'OtherSiteCategory', foreign_key:'parent_category_id'
  has_many :siblings, -> { where(parent_category_id: parent_category_id) }, class_name:'OtherSiteCategory'

  ##
  # Ensures to find or create OtherSiteCategory records according to @attributes_list of
  # Would set attribute newly_created if it is new record.
  # @attributes_list <Array of Hash> in order of top to granular levels, in format like
  #   [ {"name":"Autos \u0026 Transportation","url":"https://www.ioffer.com/c/Autos-Transportation-30000/"},
  #    {"name":"Parts \u0026 Accessories","url":"https://www.ioffer.com/c/Auto-Parts-Accessories-35000/"},
  #    {"name":"Car","url":"https://www.ioffer.com/c/Car-Parts-Accessories-35015/"} ]
  def self.import_from_attributes(site_name, attributes_list, &block)
    list = []
    full_path = ''
    level = 1
    last_parent_cat = nil
    attributes_list.each do|attr|
      cat_name = attr['name']
      full_path = (full_path == '') ? cat_name : full_path + ' > ' + cat_name
      cur_cat = last_parent_cat ?
          last_parent_cat.children.where(name: cat_name).last :
          self.where(site_name: site_name, level: 1, name: cat_name).last

      unless cur_cat
        other_site_cat_id = attr['url'].present? ? find_id_out_of_url(site_name, attr['url'] ) : nil
        cur_cat ||= self.create(site_name: site_name, name: cat_name, level: level, other_site_category_id: other_site_cat_id,
                                parent_category_id: last_parent_cat.try(:id), full_path: full_path)
        cur_cat.newly_created = true
      end
      #logger.debug '      | %40s => %d' % [full_path, cur_cat.try(:category_id) || 0]
      level += 1
      last_parent_cat = cur_cat
    end
    list
  rescue Exception => e
    logger.warn "** #{e.message}\n  #{e.backtrace.join("\n  ")}"
    list
  end

  CATEGORY_URL_REGEX = /\/(c\/[\w\-]+-|category\/)(\d+)/

  ##
  def self.find_id_out_of_url(site_name, url)
    id_value = CATEGORY_URL_REGEX.match(url).try(:[], 2)
    id_value ? id_value.to_i : nil
  end
end