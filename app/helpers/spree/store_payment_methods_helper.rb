module Spree
  module StorePaymentMethodsHelper
    def added_payment_method
      @store_payment_method.try(:payment_method) ||
        (params[:added_payment_method_id] ? ::Spree::PaymentMethod.where(id: params[:added_payment_method_id]).first : nil )
    end
  end
end