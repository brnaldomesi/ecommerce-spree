require 'rails_helper'
require 'shared/session_helper'
require 'shared/products_spec_helper'
require 'shared/users_spec_helper'

include SessionHelper
include ProductsSpecHelper
include UsersSpecHelper

RSpec.describe ::Spree::Order do
  before(:all) do
    setup_all_for_posting_products
    # Capybara.ignore_hidden_elements = false
    Spree::Config[:track_inventory_levels] = false
    create(:state_ma)
    Spree::Config[:default_country_id] = Spree::Country.first.id
  end

  after(:all) do
    cleanup_retail_products
  end

  describe 'Order Product' do
    # routes { Spree::Core::Engine.routes }

    let(:sample_fixture_file_name) { 'files/color_markers.jpg' }
    let(:sample_image_path) { File.join(ActionDispatch::IntegrationTest.fixture_path,  sample_fixture_file_name) }

    context 'Order no-other-variant via cart' do

      it 'Create Product with Images' do
        seller = signup_sample_user(:basic_user)

        product = post_product_via_requests(seller, :basic_product)

        visit logout_path
        buyer = signup_sample_user(:buyer_2)

        order = add_product_to_cart(buyer, product)

        proceed_to_checkout(order)
      end
    end

  end
end

##
# Changed the style of tests: from HTML elements interactions to manual making of requests.
# @return <Spree::Order> The order in cart state
def add_product_to_cart(user, product_or_variant)
  variant = product_or_variant.is_a?(::Spree::Product) ? product_or_variant.master : product_or_variant
  product = product_or_variant.is_a?(::Spree::Product) ? product_or_variant : product_or_variant.product
  if product_or_variant.is_a?(::Spree::Product)
    visit product_path(product)
    # click_button 'Add To Cart' #
  else
    visit variant_path(id: variant.id)
    # TODO: handle selecting variant and Add to Cart
  end
  post populate_orders_path(variant_id: variant.id, quantity: 1)

  order = Spree::Order.where(user_id: user.id, state:'cart').last
  expect(order).not_to be_nil
  line_item = order.line_items.where(variant_id: variant.id).last
  expect(line_item).not_to be_nil
  order
end


def submit_billing_address(order, address)
  address_attr = {}
  [:firstname, :lastname, :address1, :address2, :city, :state_id, :zipcode, :country_id, :phone, :id].each{|a| address_attr[a] = address.send(a) }
  patch update_checkout_path(
    state: 'address', order_id: order.id, save_user_address: true,
    order: { email: order.user.email, bill_address_attributes: address_attr, use_billing: true } )
end

def proceed_to_checkout(order)
  visit cart_path
  checkout_url = nil
  find_all(:xpath, "//a[contains(@class,'checkout')]").each do|n|
    if n[:href].include?("order_id=#{order.id}")
      checkout_url = n[:href]
    end
  end
  expect(checkout_url).not_to be_nil

  visit checkout_url
  billing_addr_label = page.body.match( Regexp.new(I18n.t('spree.billing_address'), Regexp::IGNORECASE) )
  expect(billing_addr_label).not_to be_nil

  address = order.user.addresses.last || create(:basic_address)
  submit_billing_address(order, address)
  follow_redirect!

  # Should be delivery step next.  So far not working for test
end