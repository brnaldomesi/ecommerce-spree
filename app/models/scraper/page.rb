module Scraper
  class Page < ::RetailScraperRecord
    self.table_name = 'scraper_pages'

    validates_presence_of :retail_site_id, :page_url

    # object_constants :page_type, :landing, :store, :index, :detail
    PAGE_TYPES = %w|LANDING STORE INDEX DETAIL|

    # object_constants :file_status, :not_fetched, :saved
    FILE_STATUSES = %w|NOT_FETCHED SAVED|

    belongs_to :retail_site, class_name: 'Retail::Site'
    belongs_to :retail_store, class_name: 'Retail::Store', optional: true
    belongs_to :referrer_page, class_name: 'Scraper::Page', foreign_key: 'referrer_page_id', optional: true
    alias_method :parent_page, :referrer_page
    has_many :page_requests, class_name: 'Scraper::PageRequest', foreign_key: 'scraper_page_id', dependent: :destroy

    has_many :following_pages, class_name: 'Scraper::Page', foreign_key: 'referrer_page_id'

    has_one :retail_product, class_name: 'Retail::Product', foreign_key: 'scraper_page_id'
    alias_method :product, :retail_product

    def self.which_site(url, options = {})
      u = url.is_a?(URI::Generic) ? url : URI(url)
      site = nil
      if options[:retail_site_id]
        site = ::Retail::Site.find_via_cache(options[:retail_site_id])
      end
      site ||= ::Retail::Site.find_matching_site(u.host || site.try(:domain))
      site
    end

    ##
    # If @url does not contain the domain, provide inside options[:domain].
    # @url <URI::Generic or String of some URL>
    # @options <Hash> the attributes of record
    #   :retail_site <Retail::Site> optional; provide this to avoid having to query according to +url+
    def self.find_same_page(url, options = {})
      u = url.is_a?(URI::Generic) ? url : URI(url)
      site = options[:retail_site] || which_site(u, options)
      return nil if site.nil?
      where(retail_site_id: site.id, url_path: u.path, url_params: u.sorted_query(false)).last
    end
  end
end