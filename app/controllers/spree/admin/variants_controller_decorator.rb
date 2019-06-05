module Spree
  module Admin
    VariantsController.class_eval do
      before_action :set_current_user_id, only: [:create, :clone]

      def set_current_user_id
        @object.user_id = spree_current_user.try(:id) if @object
        @new.user_id = spree_current_user.try(:id) if @new
      end

      ##
      # Copied over code and then added w/ extra current user only condition.
      def collection
        @collection = super
        @collection = @collection.where(user_id: spree_current_user.try(:id) ) if spree_current_user && !spree_current_user.admin?
        @collection
      end

    end
  end
end