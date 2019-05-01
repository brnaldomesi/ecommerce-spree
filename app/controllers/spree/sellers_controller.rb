module Spree
  class SellersController < InheritedResources::Base
    defaults :resource_class => ::Spree::User, :collection_name => 'spree_users', :instance_name => 'spree_user'

    def show
      if resource.store
        redirect_to spree_store_path(resource.store)
      else
        # TODO: if products search can handle specified seller only, change to that page.
        redirect_to spree_products_path
      end
    end
  end
end