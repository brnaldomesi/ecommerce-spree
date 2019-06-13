class ImportCategoriesToRetailScraper < ActiveRecord::Migration[5.2]
  def change
    # Only remote servers
    if Rails.env.staging? || Rails.env.production?
      db_settings = YAML::load(File.read("#{Rails.root}/config/retail_scraper_database.yml") )[Rails.env]
      `mysql -h#{db_settings['host']} -u#{db_settings['username']} -p#{db_settings['password']} -D#{db_settings['database']} < #{Rails.root}/db/categories.sql`
    end
  end
end
