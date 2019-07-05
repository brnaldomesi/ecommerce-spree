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
    # If resource is not on record of user resource actions, the Users::ResourceAction would be yielded
    # to the block, so it could perform things like increasing view count.
    # @user <Spree::User>
    # @return <Users::ResourceAction> nil if no need to save record.
    def self.save_resource_action_for(user, resource, action = 'VIEW', &block)
      return nil if user.nil? || user.id == resource.user_id
      self.find_or_create_by(
        user_id: user.id, action: action,
        resource_type: resource.class.to_s, resource_id: resource.id) do|ra|
          yield ra if block_given?
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