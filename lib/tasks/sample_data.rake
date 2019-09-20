namespace :sample_data do

  task :generate => :environment do
    users = create_users_with_common_names
    puts "Created #{users.size} users"
    assign_users_to_products(users)
    create_variants_of_products(users)
  end

  task :update => :environment do
    users = create_users_with_common_names
    puts "Created #{users.size} users"
    idx = -1
    products_query = ::Spree::Product.where(user_id: users.collect(&:id) )
    puts "  These users have #{products_query.count} products"
    products_query.all.each do|product|
      idx += 1
      puts "  #{idx}" if idx % 20 == 1

      product.update_variants!(true) do|v|
        v.user_id = product.user_id
        v.save
      end
    end
  end

  task :filter_variants => :environment do
    users = create_users_with_common_names
    puts "Created #{users.size} users"
    products_query = ::Spree::Product.where(user_id: users.collect(&:id) )
    puts "  These users have #{products_query.count} products"

    filter_variants_of_products(users)
  end

  task :import_color_names => :environment do
    ARGV.shift
    file_path = ARGV.shift
    file_path ||= File.join(Rails.root, 'doc/option_values/color_names.html')
    puts "File #{file_path} ===================================\n"

    doc = File.open( file_path ) { |f| Nokogiri::HTML(f) }
    count = 0
    doc.xpath("//tr[@class='color']").each do|color_tr|
      h = {}
      color_tr.children.each do|td|
        if td['class'] =~ /\bcolor-name\b/i
          h[:name] = td.text.strip
        elsif td['class'] =~ /\bcolor-hex\b/i
          h[:hex] = td.text.strip
        end
      end
      count += 1
      ::Spree::OptionType.where("name LIKE '%color'").each do|option_type|
        ov = option_type.option_values.where(presentation: h[:name]).first
        ov ||= ::Spree::OptionValue.new(position: count, name: h[:name], presentation: h[:name], option_type_id: option_type.id)
        ov.extra_value = h[:hex]
        ov.save
      end
      puts '%16s | %s' % [ h[:name], h[:hex] ]
    end
    puts "| Total of #{count} colors found"
  end

  ##
  # Expected format:
  # color_name,value,extra_value
  task :import_colors_from_csv => :environment do
    ARGV.shift
    file_path = ARGV.shift
    file_path ||= File.join(Rails.root, 'doc/option_values/color_values_by_neil.csv')
    puts "File #{file_path} ===================================\n"

    ::Spree::OptionType.where("name LIKE '%color'").each do|option_type|
      puts "Option Type: #{option_type.name} (#{option_type.id}) ------------------------------------"
      File.open(file_path).readlines.each_with_index do|line, count|
        cols = line.split(',')
        name = cols[0].gsub('\\', ' / ')
        ov = option_type.option_values.where(presentation: name ).first
        ov ||= ::Spree::OptionValue.new(position: count + 1, name: name, presentation: name, option_type_id: option_type.id)
        ov.extra_value = cols[2].present? ? cols[1] + ',' + cols[2] : cols[1]
        ov.save
        puts '%4d | %30s | %s' % [ov.id, ov.name, ov.extra_value]
      end
    end
  end

  ##
  # Some color combos might have mising hex values (in extra_value)
  task :fix_extra_value_of_color_option_values => :environment do
    ::Spree::OptionType.where("name LIKE '%color'").each do|ot|
      puts "Option Type: #{ot.name} (#{ot.id}) ------------------------------------"
      ot.option_values.where('name LIKE \'%/%\' OR name LIKE \'%\%\'').each do|ov|
        next if ov.extra_value.present? && ov.extra_value.index(',')
        single_colors = ov.name.split(/(\/|\\)/ )
        hex_values = single_colors.collect do|color_name|
          ot.option_values.where(name: color_name.strip).first.try(:extra_value)
        end.compact
        if hex_values.find{|v| v.blank? }
          puts '%4d | %30s | %16s | %s *** DELETE' % [ov.id, ov.name, ov.extra_value.to_s, hex_values.to_s]
          ov.destroy
        else
          puts '%4d | %30s | %16s | %s' % [ov.id, ov.name, ov.extra_value.to_s, hex_values.to_s]
          ov.update(extra_value: hex_values.join(',') )
        end
      end

      # Clean duplicates
      Spree::OptionValue.where(option_type_id: ot.id).group('name').count.each_pair do|name,count|
        if count > 1

        end
      end
    end
  end

  ################################

  def common_names
    unless @common_names
      @common_names = File.open(File.join(Rails.root, 'doc/common_names.txt') ).readlines.collect(&:strip)
    end
    @common_names
  end

  def create_users_with_common_names
    common_names.collect do|name|
      user = ::Spree::User.find_or_create_by(username: name) do|u|
        u.password = 'test1234'
        u.confirmed_at = Time.now
        u.display_name = name.titleize
        u.email = name + '@localhost'
      end
    end
  end

  def assign_users_to_products(users)
    products_query = ::Spree::Product.where('user_id IS NULL')
    product_ids = products_query.select('id').all.collect(&:id)
    avg_products_per_user = product_ids.size / users.size.to_f
    puts "  Assigning these users to #{product_ids.size} nil products"

    product_idx = 0
    users.each_with_index do|user, idx|
      products_to_get_count = (idx % 2).zero? ? avg_products_per_user.ceil : avg_products_per_user.floor
      ::Spree::Product.where(id: product_ids[product_idx, products_to_get_count] ).each do|product|
        product.update(user_id: user.id, view_count: rand(900) + 100, created_at: rand(365).days.ago )
      end
      product_idx += products_to_get_count
    end
  end

  ##
  # Products would be those owned by these users and freshly created w/o master_product_id.
  def create_variants_of_products(users)
    idx = -1
    products_query = ::Spree::Product.where(user_id: users.collect(&:id) ).where('master_product_id IS NULL')
    puts "  These users have #{products_query.count} products; making duplicates for 1/3 of them"
    products_query.all.each do|product|
      idx += 1
      puts "  #{idx}" if idx % 20 == 1
      next unless idx % 3 == 2
      users_to_get_count = rand(3) + 2 - product.slave_products.count
      duplicates = []
      1.upto(users_to_get_count) do
        p2 = product.build_clone
        p2.view_count = rand(900) + 100
        p2.created_at = product.created_at + rand(365).days
        p2.user_id = product.user_id
        p2.save

        p2.copy_variants_from!(product)
        p2.variants.each do|v2|
          diff = rand(product.price / 2) - (product.price / 4) # from -1/4 to 1/4
          v2.update(price: product.price + diff)
        end
        duplicates << p2
      end
      duplicates[ (users_to_get_count / 2.0).floor, 2 ].each do|p|
        p.txn_count = rand(100)
        p.engagement_count = p.txn_count + rand(500)
        p.gms = p.txn_count * p.price
        p.save
      end
    end
  end

  def filter_variants_of_products(users, option_types = nil)
    idx = -1
    option_types ||= Spree::OptionType.where(name: ['color', 'clothing color', 'device color'])
    option_type_ids = option_types.collect(&:id)
    option_type_ids_s = option_type_ids.collect(&:to_s).join(',')
    products_query = ::Spree::Product.all

    puts "  These users have #{products_query.count} products"
    puts "  Filtering out variants' other option types than #{option_types.collect(&:name)}"
    products_query.all.each do|product|
      idx += 1
      puts "  #{idx}" if idx % 20 == 1
      product.variants.to_a.each do|variant|
        others_query = variant.option_values_variants.joins(:option_value).where("#{Spree::OptionValue.table_name}.option_type_id NOT IN (#{option_type_ids_s})" )
        if others_query.count > 0
          puts "  .. deleting #{others_query.count} values from product #{product.id}, variant #{variant.id}"
          others_query.delete_all
          variant.really_destroy! if variant.option_values_variants.reload.size.zero?
        end
      end
    end
  end
end