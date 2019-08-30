module Spree
  class StorePaymentMethodsController < Spree::StoreController
    inherit_resources

    helper Spree::PaymentMethodsHelper

    before_action :load_collection, only: [:index]
    # before_action :load_resource, except: [:index, :create]

    def index
      session[:return_to] = request.url
      super
    end

    def create
      params.permit!
      @store_payment_method = ::Spree::StorePaymentMethod.new(params[:store_payment_method])
      @store_payment_method.store_id = spree_current_user.store.id
      create!(notice: '') { store_payment_methods_path }
    end

    private

    def collection
      @collection = ::Spree::StorePaymentMethod.where(store_id: spree_current_user.store.id).all
      instance_variable_set("@#{controller_name}", @collection)
    end

    def load_collection
      cur_payment_method_ids = collection.collect(&:payment_method_id)
      @available_payment_methods = ::Spree::PaymentMethod.all.order('position asc').to_a
      @available_payment_methods.delete_if do|pm|
        cur_payment_method_ids.include?(pm.id)
      end
    end

  end
end