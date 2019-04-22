##
# class SellerUser < DefaultCustomer
module Spree
  module PermissionSets
    class SellerUser < DefaultCustomer
      def activate!
        super

        # from Spree::PermissionSets::ProductManagement
        ::Spree::ProductUserRelation::MANAGEABLE_CLASSES.each do|klass|
          next unless klass.new.respond_to?(:user_id)
          can :manage, klass
          # do|record|
            # record.user_id == user.id # TODO: resume
        # end
        end

        # These don't have ref to product
        can :manage, Spree::Image

        # TODO: somehow the looped 'can :manage' calls don't work
        can :manage, Spree::Product
        can :manage, Spree::OptionValue
        can :manage, Spree::StockItem
        can :manage, Spree::StockLocation
      end

    end
  end
end
