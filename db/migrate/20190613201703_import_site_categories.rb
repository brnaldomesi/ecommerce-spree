class ImportSiteCategories < ActiveRecord::Migration[5.2]
  def change
    # Only remote servers
    if Rails.env.staging? || Rails.env.production?
      `bundle exec rails db -p < #{Rails.root}/db/site_categories.sql`
    end
  end
end
