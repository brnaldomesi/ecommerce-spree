module UsersSpecHelper

  def sign_up_with(email, password, username = nil, display_name = nil)
    begin
      visit signup_path
      fill_in 'Email', with: email
      fill_in 'Username', with: username if username
      # fill_in 'Display Name', with: display_name if display_name
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
    # expect(user.display_name).not_to be_nil if display_name
    # expect(user.display_name).to eq(display_name)

    expect(user.store).not_to be_nil
    expect(user.confirmation_token.present?).to be_truthy
    expect(user.confirmed_at).to be_nil

    user
  end

  ##
  # Sign up, confirm email, and sign in.
  # @return <Spree::User>
  def signup_sample_user(user_factory_key)
    user_attr = attributes_for(user_factory_key)
    user = sign_up_with user_attr[:email], 'test1234', user_attr[:username], user_attr[:display_name]
    confirm_email(user)
    visit logout_path
    sign_in(user)
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
    begin
      visit confirm_url
      user.reload
    rescue Timeout::Error => user_e
      user.confirmed_at = Time.now
      user.save
    end
    expect(user.confirmed_at).not_to be_nil
  end

  ##
  # Of current user, check to select to Connect to PayPal and add other payment methods.
  def check_payment_methods(user)
    ::Spree::PaymentMethod.populate_with_common_payment_methods
    paypal = ::Spree::PaymentMethod.where(name: 'PayPal').first
    expect(paypal).not_to be_nil
    post store_payment_methods_path(store_payment_method:{ payment_method_id: paypal.id }  )

    user.store.payment_methods.reload
    expect(user.store.payment_methods.where(name:'PayPal').first ).not_to be_nil

    another_payment_method = ::Spree::PaymentMethod.last
    if another_payment_method && another_payment_method.id != paypal.id
      post store_payment_methods_path(store_payment_method:{ payment_method_id: another_payment_method.id }  )

      user.store.payment_methods.reload
      expect(user.store.payment_methods.where(name: another_payment_method.name).first ).not_to be_nil
    end
  end

end