module Scraper
  class PageRequest < ::ApplicationRecord
    self.table_name = 'scraper_page_requests'

    validates_presence_of :scraper_run_id, :scraper_page_id

    STATUSES = %w|WAITING FETCHING SAVED OUT_OF_LIMIT NOT_FOUND SERVER_ERROR BLOCKED UNKNOWN|
    FINISHED_STATUSES = %w|SAVED OUT_OF_LIMIT NOT_FOUND SERVER_ERROR BLOCKED|
    STATUSES.each do |_status|
      define_method "#{_status.downcase}?" do
        status == "#{_status}"
      end
    end

    TRIAL_LIMIT = 5

    belongs_to :retail_site, class_name: 'Retail::Site'
    belongs_to :run, class_name: 'Scraper::Run', foreign_key: :scraper_run_id
    belongs_to :page, class_name: 'Scraper::Page', foreign_key: :scraper_page_id

    delegate :page_type, :title, :page_url, :relative_page_url, :to => :page
    delegate :scraper_class, :scraper, :abs_url, :to => :retail_site

    scope :waiting, -> { where('status IN (?)', ['WAITING']) }
    scope :stale, -> { where('status IN (?) AND created_at < ?', ['FETCHING'], 3.days.ago) }
    scope :finished, -> { where('status IN (?)', FINISHED_STATUSES) }
    scope :with_page_type, lambda { |page_type| joins(:page).where("scraper_pages.page_type='#{page_type}'") } # since Rails 5, no auto join using includes
    scope :referred_from, lambda { |page_ids|
      where('scraper_pages.referrer_page_id IN (?)', page_ids.is_a?(Array) ? page_ids : [page_ids])
    }


    def should_fetch?
      fetch_count.to_i < TRIAL_LIMIT
    end

    def finished?
      FINISHED_STATUSES.include?(status)
    end

    # @return <Retail::Store> could be nil
    def find_retail_store(agent, mechanize_page = nil)
      ::Retail::Store.find_or_build_retail_store(retail_site_id, agent, mechanize_page)
    end

  end
end