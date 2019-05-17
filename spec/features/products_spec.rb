require 'rails_helper'
require 'shared/products_spec_helper'
require 'shared/users_spec_helper'

include ProductsSpecHelper
include UsersSpecHelper

describe 'create product', type: :feature do
  # routes { Spree::Core::Engine.routes }

  let(:sample_image_url) { 'http://digg.com/static/images/apple/apple-touch-icon-57.png' }

  context 'Convert from Retail::Product' do
    it 'Convert from sample product' do
      retail_product = create_retail_product(:basic_product, [sample_image_url] )

      product = retail_product.create_as_spree_product
      expect(product.name).to eq(retail_product.title)
      expect(product.price).to eq(retail_product.price)

      # expect(product.gallery.images.size).to eq(1)
    end
  end

end