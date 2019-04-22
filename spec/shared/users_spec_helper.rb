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

end