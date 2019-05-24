class ApplicationController < ActionController::Base
  include ControllerHelpers::PageFlow
  include Spree::Core::ControllerHelpers::Auth

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
end
