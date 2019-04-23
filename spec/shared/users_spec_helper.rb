module UsersSpecHelper

  def sign_up_with(email, password)
    visit signup_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password Confirmation', with: password
    click_button 'Create'

    Spree::User.last
  end

  def sign_in
    user = create(:user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end

  def check_user_abilities(user)
    expect { user.not_to be_nil }
    expect { (user.spree_api_key.present?).to be_truthy }

    # Check abilities
    ability = ::Spree::Ability.new(user)
    puts '---- Check abilities of user'
    expect { ability.can?(:new, Spree::Product).to be_truthy }
    expect { ability.can?(:display, Spree::Taxon).to be_truthy }
    [Spree::Product, Spree::ProductOptionType, Spree::ProductProperty].each do|klass|
      expect { ability.can?(:manage, klass).to be_truthy }
    end

    puts '---- Check inabilities of user'
    expect { ability.can?(:destroy, Spree::User).not_to be_truthy }
    expect { ability.can?(:manage, Spree::Role).not_to be_truthy }
  end

end