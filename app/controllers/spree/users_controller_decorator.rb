module Spree
  UsersController.class_eval do
    helper 'spree/admin/navigation'

    before_action :check_confirm_page_to_go, only: [:index]

    def index
    end

    def access

    end

    def access_login
      if params[:username] == ApplicationController::SITE_WALL_NAME && params[:password] == ApplicationController::SITE_WALL_PASSWORD
        session[:site_wall_user] = params[:username]
        session[:site_wall_expire_time] = 1.hour.since
        return_url = params[:return_url]
        logger.debug "-> #{session[:original_uri]}, #{return_url}"
        return_url.present? ? redirect_to(return_url) : redirect_to( spree_current_user ? '/' : login_path )
      else
        # logger.debug "username #{ApplicationController::SITE_WALL_NAME} vs #{params[:username]} and password #{ApplicationController::SITE_WALL_PASSWORD} vs #{params[:password]}"
        render template: 'spree/users/access'
      end
    end

    protected

    def check_confirm_page_to_go
      url = required_to_confirm_page
      if url.present?
        session[:return_to] = request.url
        redirect_to url
      end
    end

    ##
    # Page that requires user to view or fill in when entering account pages.
    def required_to_confirm_page
      if spree_current_user.store.payment_methods.count == 0
        store_payment_methods_path
      else
        nil
      end
    end
  end
end