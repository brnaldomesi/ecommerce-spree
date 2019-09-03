require 'rails_helper'
require 'shared/session_helper'
require 'shared/products_spec_helper'
require 'shared/users_spec_helper'

include SessionHelper
include UsersSpecHelper
include ProductsSpecHelper

RSpec.describe 'Register a user', type: :feature do
  # routes { Spree::Core::Engine.routes }

  before :all do
    setup_category_taxons( [:level_one_category_taxon, :level_two_category_taxon, :level_three_category_taxon] )
  end

  context 'Registering user' do
    let :user_attr do
      attributes_for(:basic_user)
    end
    let(:email) { user_attr[:email] }
    let(:username) { user_attr[:username] }
    let(:display_name) { user_attr[:display_name] }
    let(:user) { nil }

    it 'Sign up' do
      puts '---- Sign up user'
      user = sign_up_with(user_attr[:email], 'test1234', user_attr[:username], user_attr[:display_name] )

      puts '---- Set info by IP'
      ip_user = build(:seller, :real_ip)
      begin
        # Test whether GeoIp service is working
        user.current_sign_in_ip = ip_user.current_sign_in_ip
        user.save
      rescue Timeout::Error => api_e
        user.current_sign_in_ip = nil
        sample_address = create(:sample_address)
        user.country = sample_address.country
        user.timezone = sample_address.timezone
        user.save
      end
      user.reload
      expect(user.country.present?).to be_truthy
      expect(user.timezone.present?).to be_truthy

      check_user_abilities(user)

      puts '---- Confirm email'
      confirm_email(user)

      puts '---- Relogin w/ username'
      visit logout_path
      sign_in(user)

      puts '---- Relogin w/ email'
      visit logout_path
      sign_in(user, 'test1234', 'email')

      expect(user.store).not_to be_nil
      visit account_index_path
      if user.store.payment_methods.count == 0
        expect(current_url.ends_with?(store_payment_methods_path) ).to be_truthy
        check_payment_methods(user)
      end

    end
  end

end