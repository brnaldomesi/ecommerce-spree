##
# Override of solidus_auth_devise-master/app/mailers/spree/user_mailer.rb, for trying to use
# the user.store instead of Spree::Store.default.
module Spree
  class UserMailer < BaseMailer
    def reset_password_instructions(user, token, *args)
      @store = user.store || Spree::Store.default
      @edit_password_reset_url = spree.edit_spree_user_password_url(reset_password_token: token, host: @store.url)
      mail to: user.email, from: from_address(@store), subject: "#{@store.name} #{I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions])}"
    end

    def confirmation_instructions(user, token, opts={})
      @store = user.store || Spree::Store.default
      @confirmation_url = spree.spree_user_confirmation_url(confirmation_token: token, host: @store.url)
      mail to: user.email, from: from_address(@store), subject: "#{@store.name} #{I18n.t(:subject, scope: [:devise, :mailer, :confirmation_instructions])}"
    end
  end
end
