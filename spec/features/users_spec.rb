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

      check_user_abilities(user)

      puts '---- Confirm email'
      confirm_email(user)

      puts '---- Relogin'
      visit logout_path

      sign_in(user)

    end
  end

end