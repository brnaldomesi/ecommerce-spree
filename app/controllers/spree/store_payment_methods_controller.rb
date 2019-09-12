module Spree
  class StorePaymentMethodsController < Spree::StoreController
    inherit_resources

    helper Spree::PaymentMethodsHelper

    before_action :load_collection, only: [:index]
    before_action :set_params, only: [:create, :update]
    after_action :clear_notice, except: [:index]
    # before_action :load_resource, except: [:index, :create]

    def index
      session[:return_to] = request.url
      super
    end

    def create
      @store_payment_method = ::Spree::StorePaymentMethod.new( resource_params )
      @store_payment_method.store_id = spree_current_user.store.id
      create!(notice: '') { store_payment_methods_path(added_payment_method_id: @store_payment_method.payment_method_id) }
    end

    def update
      update!(notice: '') { store_payment_methods_path }
    end

    def destroy
      super do|f|
        f.html { redirect_to store_payment_methods_path(show_other_payment_methods: params[:show_other_payment_methods], deleted_payment_method_id: resource.try(:payment_method_id) ) }
      end
    end

    private

    def set_params
      # If account_parameters is a Hash of multiple inner attributes, convert to JSON
      account_parameters = params[:store_payment_method][:account_parameters]
      if account_parameters.is_a?(Hash)
        params[:store_payment_method][:account_parameters] = account_parameters.to_json
      end
      params.permit! # let inherited_resources handle attribute permits
    end

    def clear_notice
      flash[:notice] = ''
    end

    def collection
      @collection = ::Spree::StorePaymentMethod.where(store_id: spree_current_user.fetch_store.id).includes(:payment_method).all
      instance_variable_set("@#{controller_name}", @collection)
    end

    def load_collection
      cur_payment_method_ids = collection.collect(&:payment_method_id)
      @available_payment_methods = ::Spree::PaymentMethod.all.order('position asc').to_a
      @available_payment_methods.delete_if do|pm|
        cur_payment_method_ids.include?(pm.id) || (pm.is_a?(::Spree::PaymentMethod::PayPal) && params[:show_other_payment_methods] )
      end
    end

  end
end