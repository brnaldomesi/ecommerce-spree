class ApplicationController < ActionController::Base
  include ControllerHelpers::PageFlow
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Order

  SITE_WALL_NAME = ENV['SITE_WALL_NAME']
  SITE_WALL_PASSWORD = ENV['SITE_WALL_PASSWORD']
  SITE_DOMAIN = ENV['SITE_DOMAIN']

  before_action :site_wall_authentication
  before_action :load_cart

  ##
  # These from
  def action
    params[:action].to_sym
  end

  def authorize_admin
    if respond_to?(:model_class, true) && model_class
      record = model_class
    else
      record = controller_name.to_sym
    end
    authorize! :admin, record
    authorize! action, record
  end

  def default_url_options
    if Rails.env.staging?
      SITE_DOMAIN.present? ? {:host => SITE_DOMAIN } : { only_path: true }
    else
      {}
    end
  end

  #
  # From spree/orders_controller.rb#edit
  def load_cart
    if request.method == 'GET'
      unless @order
        @order = current_order || Spree::Order.incomplete.find_or_initialize_by(guest_token: cookies.signed[:guest_token])
        authorize! :read, @order, cookies.signed[:guest_token]
        associate_user
      end
    end
  end

  protected

  def site_wall_authentication
    return unless Rails.env.staging? || Rails.env.development?

    if requires_site_wall? && !signed_in_the_site_wall? && request.path != user_access_path && request.path != user_access_login_path
      set_this_as_redirect_back
      logger.info " #{request.path} -> SITE_WALL: #{user_access_path}"
      redirect_to user_access_path
    end
  end

  def requires_site_wall?
    ( Mime::Type.lookup(request.format).html? || request.format == 'text/html') &&
      SITE_WALL_NAME.present? && SITE_WALL_PASSWORD.present?
  end

  def signed_in_the_site_wall?
    logger.info "| session[:site_wall_user] #{session[:site_wall_user]}"
    session[:site_wall_user].present? && (session[:site_wall_expire_time].nil? || session[:site_wall_expire_time] > Time.now )
  end

  def set_this_as_redirect_back(override = true)
    if override || session[:original_uri].blank?
      session[:original_uri] = request.url
    end
  end
end
