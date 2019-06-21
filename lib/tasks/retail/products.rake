namespace :products do

  desc 'Export Retail::ProductSpec name values to file doc/spec_names.txt, which can be used for properties or options'
  task :export_product_spec_names => :environment do
    saved_set = Set.new
    File.open( File.join(Rails.root, 'doc/spec_names.txt'), "w:#{Encoding::ASCII_8BIT}" ) do|f|
      ::Retail::ProductSpec.where(locale: 'en-US').select(:name).distinct.each do|spec|
        clean_name = spec.name.to_keyword_name
        puts '%30s | %30s | %s' % [spec.name, String.sanitize_keyword_name(clean_name), clean_name.valid_keyword_name? ? '**' : '' ]
        if clean_name.valid_keyword_name? && !saved_set.include?(clean_name)
          f.write clean_name + "\n"
        end
        saved_set << clean_name
      end
    end
  end

  desc 'From the file doc/spec_names.txt, populate such list of Spree::OptionType for the options of variants.'
  task :import_option_types => :environment do
    File.new( File.join(Rails.root, 'doc/spec_names.txt'), 'r' ).each_line do|line|
      next if line.blank?
      clean_name = line.to_keyword_name
      option_type = ::Spree::OptionType.find_or_create_by(name: clean_name) do|o|
        o.presentation = clean_name.titleize
      end
      puts clean_name
    end
  end

end