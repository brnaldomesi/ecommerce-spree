class ConvertCharsetForTables < ActiveRecord::Migration[5.2]
  def change
    connection = ApplicationRecord.connection
    connection.tables.each do|table|
      next if table.match(/^spree_/).nil?
      puts "  #{table}"
      connection.execute("ALTER TABLE #{table} CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci")
    end
  end
end
