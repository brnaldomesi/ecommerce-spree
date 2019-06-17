class Retail::Store < ::RetailScraperRecord
  self.table_name = 'retail_stores'

  validates_presence_of :retail_site_store_id, :retail_site_id, :store_url

  belongs_to :retail_site, class_name: 'Retail::Site', foreign_key: 'retail_site_id'

  has_many :migrations, class_name: 'Retail::StoreToSpreeUser', foreign_key: 'retail_store_id'
  has_many :spree_users, class_name: 'Spree::User', through: :migrations

end