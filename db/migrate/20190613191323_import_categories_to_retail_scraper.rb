class ImportCategoriesToRetailScraper < ActiveRecord::Migration[5.2]
  def change
    # Only remote servers
    if Rails.env.staging? || Rails.env.production?
      sql = File.read('db/categories.sql')
      statements = sql.split(/;$/)
      statements.pop
      puts "Total #{statements.size}"

      RetailScraperRecord.transaction do
        statements.each_with_index do |statement, index|
          puts "  #{index} .. " if index % 100 == 1
          connection.execute(statement)
        end
      end
    end
  end
end
