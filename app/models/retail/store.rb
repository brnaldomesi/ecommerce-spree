class Retail::Store < ::RetailScraperRecord
  self.table_name = 'retail_stores'

  validates_presence_of :retail_site_store_id, :retail_site_id, :store_url

  belongs_to :retail_site, class_name: 'Retail::Site', foreign_key: 'retail_site_id'

  # @return <Retail::Store> could be nil
  def self.find_or_build_retail_store(retail_site_id, agent, mechanize_page = nil)
    store_attr = agent.find_retail_store_attributes(mechanize_page || agent.current_page)
    store = nil
    if store_attr.size > 0
      store = self.where(retail_site_id: retail_site_id, retail_site_store_id: store_attr[:retail_site_store_id] ).last
      store ||= self.new( store_attr.merge(retail_site_id: retail_site_id) )
    end
    store
  end

  def self.find_or_create_retail_store(retail_site_id, agent, mechanize_page = nil)
    store = find_or_build_retail_store(retail_site_id, agent, mechanize_page)
    store.save if store && store.new_record?
    store
  end

end