class Retail::Site < ::ApplicationRecord

  self.table_name = 'retail_sites'

  attr_accessor :forced_scheme, :locale_words_count # , :headers

  validates_presence_of :name, :domain

  has_many :products, class_name: 'Retail::Product', foreign_key: 'retail_site_id', dependent: :destroy
  has_many :stores, class_name: 'Retail::Store', foreign_key: 'retail_site_id', dependent: :destroy

  before_save :set_defaults

  def scraper_class
    ::Scraper::Base.scraper_class(name)
  end

  def scraper
    @scraper ||= scraper_class.new
  end

  alias_method :agent, :scraper

  def abs_url(url)
    full_url = url
    full_url.insert(0, (forced_scheme || 'http') + '://' + domain ) unless full_url =~ /^(ht|f)tps?:\/\//
    full_url
  end

  def headers
    {'X-Requested-With' => 'XMLHttpRequest'}
  end

  ##
  # @url should be the full address including site domain; else, include domain in options like domain: 'ioffer.com'
  def self.find_matching_site(url, options = {})
    domain = options[:domain]
    unless domain.present?
      domain ||= URI::HTTP.domain_base(url, false)
    end
    logger.info "| domain #{domain} of #{url}"
    site = find_or_set("retail_site_by_domain:#{domain}") do
      where(domain: domain).last
    end
    site
  end

  private

  def set_defaults
    self.site_scraper = scraper_class.to_s if site_scraper.blank?
    begin
      self.domain = URI::HTTP.domain_base(domain)
    rescue Exception => domain_e
      logger.warn 'Invalid domain: ' + domain_e.message
    end
  end
end