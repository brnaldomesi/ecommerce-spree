##
# class SellerUser < DefaultCustomer
module Spree
  module PermissionSets
    class DefaultCustomer < PermissionSets::Base
      def activate!
        super

        # from Spree::PermissionSets::ProductManagement
        ::Spree::ProductUserRelation::MANAGEABLE_CLASSES.each do|klass|
          next unless klass.new.respond_to?(:user_id)
          can :manage, klass # do|record|
            # record.user_id == user.id
          # end
        end

        # These don't have ref to product
        can :manage, Spree::Image

      end

    end
  end
end
