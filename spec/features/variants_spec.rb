require 'rails_helper'
require 'shared/products_spec_helper'
require 'shared/users_spec_helper'

include ProductsSpecHelper
include UsersSpecHelper

RSpec.describe ::Spree::Product do
  before(:example) do
    setup_all_for_posting_products
  end

  after(:example) do
    cleanup_retail_products
  end

  describe 'create product', type: :feature do
    # routes { Spree::Core::Engine.routes }

    let(:sample_image_url) { 'http://digg.com/static/images/apple/apple-touch-icon-57.png' }

    context 'Post Variant of Product' do
      let :user_attr do
        attributes_for(:basic_user)
      end

      it 'Register user and create variant product' do
        puts '---- Sign up user'
        user = sign_up_with(user_attr[:email], 'test1234', user_attr[:username], user_attr[:display_name] )

        puts '---- Confirm email'
        confirm_email(user)

        puts '---- Relogin w/ username'
        visit logout_path
        sign_in(user)

        retail_product = create_retail_product(:shirt_retail_product, [sample_image_url] )
        product = retail_product.create_as_spree_product
        product.update_attributes(user_id: user.id)

        puts '--- Add option types'
        first_option_type = ::Spree::OptionType.first
        second_option_type = ::Spree::OptionType.last
        page.driver.put spree.admin_product_path(id: product.slug, product: {
            option_type_ids: "#{first_option_type.id},#{second_option_type.id}"
          })
        product.reload
        expect( product.option_types.collect(&:id).include?(first_option_type.id) ).to be_truthy
        expect( product.option_types.collect(&:id).include?(second_option_type.id) ).to be_truthy

        puts "--- Post variant w/ `#{first_option_type.name}` of #{first_option_type.option_values.count} values"
        page.driver.post spree.admin_product_variants_path(product_id: product.slug, variant: {
            price: product.price.to_f, cost_currency: 'USD', option_value_ids: first_option_type.option_values.collect(&:id)
          })
        product.reload
        expect( product.variants_including_master.count ).to eq( first_option_type.option_values.count )
        product.variants_including_master.each do|variant|
          expect( variant.user_id ).to eq(user.id)
        end
      end
    end

  end
end