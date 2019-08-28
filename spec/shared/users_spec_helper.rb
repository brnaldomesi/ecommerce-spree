module UsersSpecHelper

  def sign_up_with(email, password, username = nil, display_name = nil)
    begin
      visit signup_path
      fill_in 'Email', with: email
      fill_in 'Username', with: username if username
      fill_in 'Display Name', with: display_name if display_name
      fill_in 'Password', with: password
      fill_in 'Password Confirmation', with: password
      click_button 'Create'
    rescue Exception => e
      raise e unless e.is_a?(::Errno::ECONNREFUSED) # test mail recipient service like mailcatcher not running
      puts "** Ignore exception during registration request: #{e}"
    end
    user = Spree::User.last
    expect(user.email).to eq(email)
    expect(user.username).not_to be_nil if username
    expect(user.username).to eq(username)
    expect(user.login).to eq(username)
    expect(user.display_name).not_to be_nil if display_name
    expect(user.display_name).to eq(display_name)

    expect(user.store).not_to be_nil
    expect(user.confirmation_token.present?).to be_truthy
    expect(user.confirmed_at).to be_nil

    user
  end

  def sign_in(user, password = 'test1234', which_login_attribute = 'username')
    visit login_path
    fill_in 'Email or Username', with: (which_login_attribute.to_s == 'email' ? user.email : user.username || user.email)
    fill_in 'Password', with: password || user.password
    click_button 'Login'
    expect(page).not_to have_content 'Invalid email or password'
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

  def confirm_email(user)
    confirm_url = Spree::Core::Engine.routes.url_helpers.spree_user_confirmation_url(confirmation_token: user.confirmation_token)
    visit confirm_url
    user.reload
    expect(user.confirmed_at).not_to be_nil
  end

end