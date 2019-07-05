module Users
  class ResourceAction < ApplicationRecord
    self.table_name = 'users_resource_actions'

    MAX_AGE = 1.month

    belongs_to :user, class_name: 'Spree::User'

    validates_presence_of :user_id, :resource_type, :resource_id

    before_create :clean_records

    def resource
      resource_type.constantize.where(id: resource_id).first
    end

    ##
    #
    # @user <Spree::User>
    # @return <Users::ResourceAction> nil if no need to save record.
    def self.save_view_count_for(user, resource)
      return nil if user.nil? || user.id == resource.user_id
      self.find_or_create_by(
        user_id: user.id, action:'VIEW',
        resource_type: resource.class.to_s, resource_id: resource.id) do|ra|
          if resource.respond_to?(:view_count)
            resource.update(view_count: resource.view_count.to_i + 1)
            logger.info "| #{resource.class}(#{resource.id}) viewed by #{user.login}(#{user.id}) => #{resource.view_count + 1}"
          end
        end
    end

    ##
    # Deletes the records for user that have expired after +MAX_AGE+.
    def self.clean_for_user(user_id)
      self.where(user_id: user_id).where('created_at < ?', MAX_AGE.ago).delete_all
    end

    protected

    def clean_records
      self.class.clean_for_user(user_id) if user_id
    end
  end
end