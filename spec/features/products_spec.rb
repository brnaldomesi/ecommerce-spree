require 'rails_helper'
require 'shared/products_spec_helper'
require 'shared/users_spec_helper'

include ProductsSpecHelper
include UsersSpecHelper

RSpec.describe ::Spree::Product do
  before(:example) do
    create(:level_thee_other_site_category)
    Category.find_or_create_categories_taxon
    setup_category_taxons( [:level_one_category_taxon, :level_two_category_taxon, :level_three_category_taxon] )
    setup_site_categories('ioffer', [:level_one_site_category, :level_two_site_category, :level_three_site_category], true )
    setup_option_types_and_values
  end

  after(:example) do
    cleanup_retail_products
  end

  describe 'create product', type: :feature do
    # routes { Spree::Core::Engine.routes }

    let(:sample_image_url) { 'http://digg.com/static/images/apple/apple-touch-icon-57.png' }

    context 'Convert from Retail::Product' do
      it 'Convert from sample product' do
        retail_product = create_retail_product(:shirt_retail_product, [sample_image_url] )
        expect(retail_product.leaf_site_category).not_to be_nil
        expect(retail_product.leaf_site_category.mapped_taxon_id).not_to be_nil

        # is find_by_full_path
        product = retail_product.create_as_spree_product
        expect(product.name).to eq(retail_product.title)
        expect(product.price).to eq(retail_product.price)
        expect(product.taxons.under_categories.first.id).to eq(retail_product.leaf_site_category.mapped_taxon_id)

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

      end
    end

  end
end