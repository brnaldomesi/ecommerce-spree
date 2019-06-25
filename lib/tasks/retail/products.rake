namespace :products do

  desc 'Export Retail::ProductSpec name values to file doc/spec_names.txt, which can be used for properties or options'
  task :export_product_spec_names => :environment do
    saved_set = Set.new
    File.open(File.join(Rails.root, 'doc/spec_names.txt'), "w:#{Encoding::ASCII_8BIT}") do |f|
      ::Retail::ProductSpec.where(locale: 'en-US').select(:name).distinct.each do |spec|
        clean_name = spec.name.to_keyword_name
        puts '%30s | %30s | %s' % [spec.name, String.sanitize_keyword_name(clean_name), clean_name.valid_keyword_name? ? '**' : '']
        if clean_name.valid_keyword_name? && !saved_set.include?(clean_name)
          f.write clean_name + "\n"
        end
        saved_set << clean_name
      end
    end
  end

  desc 'From the file doc/spec_names.txt, populate such list of Spree::OptionType for the options of variants.'
  task :import_option_types => :environment do
    File.new(File.join(Rails.root, 'doc/spec_names.txt'), 'r').each_line do |line|
      next if line.blank?
      clean_name = line.to_keyword_name
      next unless ::Spree::OptionType.valid_option_name?(clean_name)
      option_type = ::Spree::OptionType.find_or_create_by(name: clean_name) do |o|
        o.presentation = clean_name.titleize
      end
      puts clean_name
    end
  end

  desc 'Recall source Retail::Product and create option values & product variants'
  task :migrate_options => :environment do
    total_count = 0
    new_products_count = 0
    fixed_options_count = 0
    added_variants_count = 0
    ::Retail::ProductToSpreeProduct.includes(:retail_product, :spree_product).each do |product_copy|
      next if product_copy.retail_product.nil? || product_copy.retail_product.product_specs.size < 2

      # at least the spec name needs to exist in current reviewed set of option types
      if product_copy.spree_product
        previous_options_count = product_copy.spree_product.option_types.size
        previous_variants_count = product_copy.spree_product.variants_including_master.count
        product_copy.spree_product.copy_product_specs_from_retail_product!(product_copy.retail_product)

        product_copy.spree_product.reload
        fixed_options_count += 1 if product_copy.spree_product.option_types.reload.size > previous_options_count
        added_variants_count += 1 if product_copy.spree_product.variants_including_master.reload.count > previous_variants_count
      else
        product_copy.retail_product.create_as_spree_product
        new_products_count += 1
      end
      puts '%7d => %5d | %60s | %3d | %3d option_types' %
               [product_copy.retail_product_id, product_copy.spree_product_id || 0, product_copy.retail_product.title.strip[0, 60], product_copy.retail_product.product_specs.size, product_copy.spree_product.option_types.count]
      total_count += 1
    end
    puts '#' * 60
    puts "Total #{total_count}, #{new_products_count} new"
    puts "Existing ones had #{fixed_options_count} options-fixed, #{added_variants_count} variants-added"
  end

end