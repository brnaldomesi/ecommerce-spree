require 'rails_helper'
require 'shared/users_spec_helper'

include UsersSpecHelper

RSpec.describe 'create product', type: :feature do
  # routes { Spree::Core::Engine.routes }

  context 'registering user' do
    let :user_attr do
      attributes_for(:basic_user)
    end

    it 'sign up first' do
      user = sign_up_with(user_attr[:email], 'test1234')
      expect { user.not_to be_nil }

      # Check abilities
      ability = ::Spree::Ability.new(user)
      puts '---- check abilities of user'
      expect { ability.can?(:new, Spree::Product).to be_truthy }
      expect { ability.can?(:display, Spree::Taxon).to be_truthy }
      [Spree::Product, Spree::ProductOptionType, Spree::ProductProperty].each do|klass|
        expect { ability.can?(:manage, klass).to be_truthy }
      end

      puts '---- check inabilities of user'
      expect { ability.can?(:destroy, Spree::User).not_to be_truthy }
      expect { ability.can?(:manage, Spree::Role).not_to be_truthy }

    end
  end

end