##
# Equivalent to some one calling a crawler, the initiated process to fetch pages and control running of
# following pages.
module Scraper
  class Run < ::ApplicationRecord
    self.table_name = 'scraper_runs'

    validates_presence_of :retail_site_id


    belongs_to :retail_site, class_name: 'Retail::Site', foreign_key: 'retail_site_id'
    alias_method :site, :retail_site
    has_many :page_requests, class_name: 'Scraper::PageRequest', foreign_key: 'scraper_run_id', dependent: :destroy
    has_many :pages, class_name: 'Scraper::Page', foreign_key: 'scraper_run_id', through: :page_requests

  end
end