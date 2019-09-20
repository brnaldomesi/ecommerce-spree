require File.join(Rails.root, 'lib/spree/option_type_service')

include Spree::OptionTypeService

namespace :option_values do
  task :import_color_names => :environment do
    ARGV.shift
    file_path = ARGV.shift
    file_path ||= File.join(Rails.root, 'doc/option_values/color_names.html')
    puts "File #{file_path} ===================================\n"

    import_color_names_from_file(file_path)
  end

  ##
  # Expected format:
  # color_name,value,extra_value
  task :import_colors_from_csv => :environment do
    ARGV.shift
    file_path = ARGV.shift
    file_path ||= File.join(Rails.root, 'doc/option_values/color_values_by_neil.csv')
    puts "File #{file_path} ===================================\n"

    import_colors_from_csv(file_path)
  end

  ##
  # Some color combos might have missing hex values (in extra_value).
  # Also fixes position values of single color to be top of multiple.
  task :fix_color_option_values => :environment do
    fix_color_option_values
  end
end