module Users
  class ResourceActionsController < ::InheritedResources::Base
    helper 'spree/admin/navigation'

    before_action :set_for_current_user, only: [:create]

    protected

    ##
    # Sets :user_id in record's params
    def set_for_current_user
      h = params[:users_resource_action] || {}
      h[:user_id] = spree_current_user.try(:id)
      params[:users_resource_action] = h
    end
  end
end