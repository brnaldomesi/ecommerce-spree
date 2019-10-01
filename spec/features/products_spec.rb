require 'rails_helper'
require 'shared/products_spec_helper'
require 'shared/users_spec_helper'

include ProductsSpecHelper
include UsersSpecHelper

RSpec.describe ::Spree::Product do
  before(:all) do
    setup_all_for_posting_products
    Capybara.ignore_hidden_elements = false
  end

  after(:all) do
    cleanup_retail_products
  end

  describe 'create product', type: :feature do
    # routes { Spree::Core::Engine.routes }

    let :user_attr do
      attributes_for(:basic_user)
    end
    let(:sample_image_url) { 'http://digg.com/static/images/apple/apple-touch-icon-57.png' }
    let(:sample_fixture_file_name) { 'color_markers.jpg' }
    let(:sample_image_path) { File.join(ActionDispatch::IntegrationTest.fixture_path, 'files', sample_fixture_file_name) }

    context 'Convert from Retail::Product' do
      it 'Convert from sample product' do
        retail_product = create_retail_product(:shirt_retail_product, [sample_image_url] )
        expect(retail_product.leaf_site_category).not_to be_nil
        expect(retail_product.leaf_site_category.mapped_taxon_id).not_to be_nil

        # is find_by_full_path
        sku = 'ION8981'
        product = retail_product.create_as_spree_product(false, sku: sku)
        expect(product.name).to eq(retail_product.title)
        expect(product.price).to eq(retail_product.price)
        expect(product.sku).to eq(sku)
        if product.taxons.present? && retail_product.leaf_site_category.mapped_taxon # sometimes mappings b/w SiteCategory and Category don't work
          expect(product.taxons.under_categories.first.id).to eq(retail_product.leaf_site_category.mapped_taxon_id)
        end
        migration = ::Retail::ProductToSpreeProduct.where(retail_product_id: retail_product.id, spree_product_id: product.id).first
        expect(migration).not_to be_nil
        retail_product.reload
        expect(retail_product.migrations.collect(&:spree_product_id).include?(product.id) ).to be_truthy
        expect(retail_product.spree_products.collect(&:id).include?(product.id) ).to be_truthy
        product.reload
        expect(product.migration).not_to be_nil
        expect(product.migration.retail_product_id).to eq(retail_product.id)

        # properties
        matching_color_property = product.product_properties.includes(:property).find{|p| p.property.name == 'color' && (p.value == 'blue white' || p.value == 'white blue') }
        expect(matching_color_property).not_to be_nil

        matching_material_property = product.product_properties.includes(:property).find{|p| p.property.name == 'material' && p.value == 'cotton' }
        expect(matching_material_property).not_to be_nil

        # variants
        variant_ids = product.variants_including_master.all.collect(&:id)
        option_value_variants = ::Spree::OptionValuesVariant.where(variant_id: variant_ids).includes(:option_value)
        %w|white blue|.each do|_color|
          matching_color_value = option_value_variants.find{|ovv| ovv.option_value.option_type.name == 'color' && ovv.option_value.name == _color }
          expect(matching_color_value).not_to be_nil
        end
        matching_cotton_value = option_value_variants.find{|ovv| ovv.option_value.option_type.name == 'material' && ovv.option_value.name == 'cotton' }
        expect(matching_cotton_value).not_to be_nil

        # Download could be problem
        actual_product_photos_count = retail_product.product_photos.collect(&:image_url).compact.size
        expect(product.gallery.images.size).to eq( actual_product_photos_count )

        # Another user wants post this product
        user = sign_up_with(user_attr[:email], 'test1234', user_attr[:username], user_attr[:display_name] )
        expect(user).not_to be_nil

        page.driver.get spree.new_admin_product_path(product: { master_product_id: product.id } )
        click_button 'Create'

        latest_product = ::Spree::Product.last
        expect(latest_product.id).not_to eq(product.id)
        expect(latest_product.master_product_id).to eq(product.id)
        expect(latest_product.user_id).to eq(user.id)
        expect(latest_product.master).not_to be_nil
        expect(latest_product.master.user_id).to eq(user.id)
        expect(latest_product.images.size).to eq(product.images.size)
        expect(latest_product.sku).not_to eq(sku)
      end
    end

    context 'Create Product Via Page Request' do

      it 'Create Product with Images' do
        user = signup_sample_user(:basic_user)

        product = post_product_via_pages(user, :basic_product, sample_image_path)
      end
    end

  end
end