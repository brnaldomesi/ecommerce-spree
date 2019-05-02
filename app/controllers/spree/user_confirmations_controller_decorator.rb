module Spree
  UserConfirmationsController.class_eval do

    protected

    def after_confirmation_path_for(resource_name, resource)
      signed_in?(resource_name) ? spree.account_path : spree.login_path
    end

  end
end