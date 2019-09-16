namespace :sample_products do

  ##
  # Based on directory's list of images w/ specified categories, product names and colors,
  # generate sample products accordingly.
  # Directory in order of:
  #   Category > Sub-Category > External Site > Product Name > Color Variant Value > images
  # Different order would crash.
  task :import_from_images => :environment do
    ARGV.shift
    root_dir = ARGV.shift
    puts "At directory #{root_dir}"

    Dir.foreach(root_dir) do|top_dir|
      next if top_dir.size < 3 || File.file?(top_dir)

      import_from_this_directory(root_dir, [top_dir] )

    end

  end

  private

  CATEGORY_PATH_ALIASES = {
      %w(Clothing Men) => 'Men\'s Clothing',
      %w(Clothing Mens) => 'Men\'s Clothing',
      %w(Clothing Women) => 'Women\'s Clothing',
      %w(Clothing Womens) => 'Women\'s Clothing',
      %w(Handbags) => 'Bags & Shoes',
      %w(Shoes) => 'Bags & Shoes',
      %w(Shoes Men) => 'Men\'s Shoes',
      %w(Shoes Mens) => 'Men\'s Shoes',
      %w(Shoes Women) => 'Women\'s Shoes',
      %w(Shoes Womens) => 'Women\'s Shoes',
    }

  def convert_path_to_full(path)
    CATEGORY_PATH_ALIASES[path] || path
  end

  ##
  # @root_path <String> the initial root of source
  # @path <Array of path folder names or String of full path>
  # @parent_category <Spree::CategoryTaxon>
  # @return <nil or String or Hash> If images present, would return a hash of :images and the other ?option_type?: ?option_value? such as color:'Blue'; if only image file, String of file full path; else nil
  def import_from_this_directory(root_path, path, parent_category = nil)
    folder_names = path.is_a?(Array) ? path : path.to_s.split('/')
    full_dir_name = convert_path_to_full(folder_names)
    parent_category ||= Spree::CategoryTaxon.root
    sub_cat = parent_category.children.where(name: full_dir_name ).first
    sub_cat ||= Spree::CategoryTaxon.where(name: full_dir_name ).order('depth asc').first || parent_category
    return nil if sub_cat.nil?

    full_path = File.join(root_path, *folder_names)
    if File.file?(full_path)
      return full_path =~ /\.(jpe?g|jp2|png|gif)\Z/ ? full_path : nil
    end
    indent = '  ' * (folder_names.size - 1)
    puts "#{indent}#{folder_names.last} | in category #{sub_cat.try(:name)} (#{sub_cat.try(:id)}) ------------"

    images = []
    Dir.foreach(full_path) do|sub_dir|
      next if sub_dir.size < 3
      unless File.file?(sub_dir)
        product_h = import_from_this_directory(root_path, folder_names + [sub_dir], sub_cat)

        if product_h.is_a?(Hash)
          product_h[:name] = folder_names.last
          puts "#{indent} | #{product_h} |" if product_h

          product = create_product_and_variant(product_h)

        elsif product_h.is_a?(String)
          images << product_h
        end
      end
    end

    return images.present? ? { images: images, color: folder_names.last, category: sub_cat } : nil
  end

  ##
  # Finds or else creates the product.  Adds CategoryTaxon is there's :category in argument hash.
  # Creates variant if there's :color, would find or create teh variant.
  def create_product_and_variant(product_h, user = nil)
    product = ::Spree::Product.where(name: product_h[:name].strip ).first # removed condition user_id: user.id,
    user ||= product.try(:user) || ::Spree::User.limit( Spree::User.count - 3 ).all.shuffle.first
    product ||= ::Spree::Product.create(
      name: product_h[:name].strip,
      description: product_h[:name].titleize + ' in various colors and sizes',
      available_on: Time.now,
      shipping_category_id: ::Spree::ShippingCategory.default.try(:id),
      price: 20 + rand(50),
      user_id: user.id
    )
    puts '------------------------------------------------------'
    puts "| Product (#{product.id}): #{product.name}"
    category_taxon = product_h[:category]
    if category_taxon
      product.taxons << category_taxon unless product.taxons.find{|ta| ta.id == category_taxon.id }
      product.option_types = ::Spree::OptionType.default_option_types( [category_taxon.name] )
      product.save
    end

    if (color = product_h[:color] )
      puts "    color: #{color}"
      color_option_type = product.option_types.find{|ot| ot.name =~ /color\Z/i }
      if color_option_type
        matching_ov = ::Spree::OptionValue.find_or_create_by(option_type_id: color_option_type.id, name: color) do|ov|
          ov.presentation = ov.name.titleize
        end
        variants_count = product.variants.where(option_values_variants:['option_value_id=?', matching_ov.id] ).count
        size_option_type = product.option_types.to_a.find{|ot| ot.name =~ /size\Z/i }
        size_option_values = size_option_type.option_values.offset( rand(size_option_type.option_values.count - 8 + variants_count) ).all
        first_size_variant = nil
        0.upto(7 - variants_count) do|i|
          size_ov = size_option_values[i]
          next if size_ov.nil?
          size_variant = product.variants.where(option_values_variants:['option_value_id=?', matching_ov.id] ).to_a.find do|v|
            v.option_values_variants.find{|_ov| _ov.option_value_id == size_ov.id }
          end
          puts "      size: #{size_ov.name}"
          unless size_variant # make variant based on current option_type_value
            size_variant ||= ::Spree::Variant.create(product_id: product.id, user_id: user.id)
          end
          first_size_variant ||= size_variant
          unless size_variant.option_values_variants.reload.where(option_value_id: matching_ov.id).first
            size_variant.option_values_variants << ::Spree::OptionValuesVariant.create(variant_id: size_variant.id, option_value_id: matching_ov.id)
          end
          unless size_variant.option_values_variants.reload.where(option_value_id: size_variant.id).first
            size_variant.option_values_variants << ::Spree::OptionValuesVariant.create(variant_id: size_variant.id, option_value_id: size_ov.id)
          end
        end

        # Copies of images only 1st variant
        if (images = product_h[:images] ).present? && first_size_variant.gallery.images.count < images.size
          images.each_with_index do|image_file_path, image_i|
            variant_for_images = image_i == 0 && product.master.gallery.images.count.zero? ? product.master : first_size_variant
            Spree::Image.create(:attachment => File.open(image_file_path), :viewable => variant_for_images)
          end
        end
      end
    end
    product
  end
end