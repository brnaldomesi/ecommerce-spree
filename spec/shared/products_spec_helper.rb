module ProductsSpecHelper


  def create_retail_product(product_factory_key, image_urls = [], properties = {})
    product = create(product_factory_key)
    product.product_photos = image_urls.collect do|url|
      p = ::Retail::ProductPhoto.create(retail_product_id: product.id, url: url)
      p.remote_image_url = url
      p.save
      p
    end
    expect(product.site_category).not_to be_nil
    expect(product.site_category.name).to eq(product.category_names.last)

    product
  end

  def cleanup_retail_products
    ::Retail::Product.all.each(&:destroy)
  end

  ###########################################

  def setup_all_for_posting_products
    create(:level_thee_other_site_category)
    Category.find_or_create_categories_taxon
    setup_category_taxons( [:level_one_category_taxon, :level_two_category_taxon, :level_three_category_taxon] )
    setup_site_categories('ioffer', [:level_one_site_category, :level_two_site_category, :level_three_site_category], true )
    setup_option_types_and_values
  end

  # @category_taxon_factory_keys <Array of symbols> list of factory keys that represent a path of multiple levels.
  def setup_category_taxons(category_taxon_factory_keys)
    categories_taxon = ::Spree::CategoryTaxon.find_or_create_categories_taxon
    current_node = categories_taxon
    @category_taxons = category_taxon_factory_keys.collect do|factory_key|
      t = create(factory_key, taxonomy_id: categories_taxon.taxonomy_id)
      t.move_to_child_of( current_node )
      current_node = t
    end
  end

  ##
  # @site_category_factory_keys <Array of symbols> list of factory keys that represent a path of multiple levels.
  def setup_site_categories(site_name, site_category_factory_keys, mapping_to_category_taxons = true)
    current_node = ::SiteCategory.root_for(site_name)
    categories_taxon = ::Spree::CategoryTaxon.find_or_create_categories_taxon.children.try(:first)
    @site_categories = []
    site_category_factory_keys.each do|factory_key|
      t = create(factory_key, site_name: site_name,
        mapped_taxon_id: mapping_to_category_taxons ? categories_taxon.try(:id) : nil)
      categories_taxon = categories_taxon.children.first if mapping_to_category_taxons && categories_taxon
      t.move_to_child_of( current_node )
      current_node = t
      @site_categories << t
    end
    @site_categories
  end

  ##
  # Basic Spree::OptionType and OptionValue
  def setup_option_types_and_values
    if ::Spree::OptionType.count.zero?
      option_type_color = create(:option_type_color)
      option_type_size = create(:option_type_size)
      option_type_material = create(:option_type_material)
      %w|white black grey red|.each{|_color| create("option_value_#{_color}".to_sym, option_type: option_type_color) }
      %w|xs s m l xl|.each{|_size| create("option_value_#{_size}".to_sym, option_type: option_type_size) }
      %w|cotton silk metal aluminum|.each{|_m| create("option_value_#{_m}".to_sym, option_type: option_type_material) }
    end
  end

  #################################
  # Capybara

  def fill_into_product_form(product_attr)
    product_attr.each_pair do|k, v|
      if v
        begin
          find(:xpath, "//*[@name='product[#{k}]']").set(v )
        rescue Capybara::ElementNotFound
          puts "** Cannot find product field #{k}"
        end
      end
    end
  end

  ##
  # @options
  #   :auto_ensure_available <Boolean> default true; somehow form submission has product created but
  #     available_on stays nil.  Never see such behavior in real run.
  #   :auto_ensure_user_id <Boolean> default true; somehow product create cannot set user_id
  # @return <Spree::Product>
  def post_product_via_pages(user, product_key, sample_image_path = nil, options = {})
    auto_ensure_available = options[:auto_ensure_available]
    auto_ensure_available ||= true
    auto_ensure_user_id = options[:auto_ensure_available]
    auto_ensure_user_id ||= true


    product_attr = attributes_for(product_key)
    visit new_admin_product_path(form:'form_in_one')
    expect(page.driver.status_code).to eq 200

    fill_into_product_form(product_attr)
    if sample_image_path
      find_all(:xpath, "//input[@name='product[uploaded_images][][attachment]']").last.attach_file(sample_image_path)
    end
    click_on('Create')

    product = ::Spree::Product.where(user_id: user.id).last
    expect(product).not_to be_nil
    expect(product.master).not_to be_nil
    if product_attr[:taxon_ids].present?
      current_taxon_ids = product.taxons.collect(&:id)
      product_attr[:taxon_ids].split(',').each do|_tid|
        expect(current_taxon_ids).to include(_tid.to_i )
      end
    end
    expect(product.gallery.images.size).to eq(1) if sample_image_path
    expect(product.name).to eq(product_attr[:name])
    expect(product.description[0,20] ).to eq(product_attr[:description][0,20] )

    product.available_on = Time.now if auto_ensure_available && product.available_on.nil?
    if auto_ensure_user_id
      product.user_id = user.id
      product.save

      product.master.user ||= product.user
      product.master.save
    end

    visit product_path(product)
    expect(page.driver.status_code).to eq 200

    product
  end
end