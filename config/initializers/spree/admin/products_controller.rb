module Spree
  module Admin
    ProductsController.class_eval do
      before_action :set_current_user_id, only: [:create]

      def set_current_user_id
        @object.user_id = spree_current_user.try(:id) if @object
      end

    end # eval
  end
end