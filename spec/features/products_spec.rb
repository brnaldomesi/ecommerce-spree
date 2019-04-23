require 'rails_helper'
require 'shared/users_spec_helper'

include UsersSpecHelper

RSpec.describe 'create product', type: :feature do
  # routes { Spree::Core::Engine.routes }

  context 'registering user' do
    let :user_attr do
      attributes_for(:basic_user)
    end
    let(:email) { user_attr[:email] }

    it 'sign up first' do
      puts '---- Sign up user 1st'
      user = sign_up_with(user_attr[:email], 'test1234')

      check_user_abilities(user)

    end
  end

end