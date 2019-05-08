require 'rails_helper'
require 'shared/users_spec_helper'

include UsersSpecHelper

RSpec.describe 'Register a user', type: :feature do
  # routes { Spree::Core::Engine.routes }

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
      user.current_sign_in_ip = ip_user.current_sign_in_ip
      user.save
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

    end
  end

end