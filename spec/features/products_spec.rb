require 'rails_helper'
require 'shared/products_spec_helper'
require 'shared/users_spec_helper'

include ProductsSpecHelper
include UsersSpecHelper

RSpec.describe ::Spree::Product do
  before(:example) do
    create(:level_thee_other_site_category)
    Category.find_or_create_categories_taxon
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

        product = retail_product.create_as_spree_product
        expect(product.name).to eq(retail_product.title)
        expect(product.price).to eq(retail_product.price)

        # Download could be problem
        actual_product_photos_count = retail_product.product_photos.collect(&:image_url).compact.size
        expect(product.gallery.images.size).to eq( actual_product_photos_count )

      end
    end

  end
end