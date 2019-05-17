require 'rails_helper'
require 'shared/users_spec_helper'

include UsersSpecHelper

describe 'create product', type: :feature do
  # routes { Spree::Core::Engine.routes }

  let(:sample_image_path) { Rails.root.to_s + '/app/assets/images/samples/color_sponge.jpg' }

  context 'Convert from Retail::Product' do
    it 'Convert from sample product' do
      retail_product = build(:basic_product)
      product = ::Retail::Product.convert_to_spree_product(retail_product)
      expect(product.name).to eq(retail_product.title)
      expect(product.price).to eq(retail_product.price)
    end
  end

end