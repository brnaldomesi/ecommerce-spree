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
    option_type_color = create(:option_type_color)
    option_type_size = create(:option_type_size)
    option_type_material = create(:option_type_material)
    %w|white black grey red|.each{|_color| create("option_value_#{_color}".to_sym, option_type: option_type_color) }
    %w|xs s m l xl|.each{|_size| create("option_value_#{_size}".to_sym, option_type: option_type_size) }
    %w|cotton silk metal aluminum|.each{|_m| create("option_value_#{_m}".to_sym, option_type: option_type_material) }
  end
end