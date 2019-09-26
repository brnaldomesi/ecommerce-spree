module Spree
  module CheckoutHelperExtension

    IMPLEMENTED_PAYMENT_METHOD_TYPES = ['Spree::PaymentMethod::CreditCard', 'Spree::PaymentMethod::PayPal']
    def has_implemented_payment?(payment_method)
      IMPLEMENTED_PAYMENT_METHOD_TYPES.include?(payment_method.type)
    end

    def store_payment_account_parameters(order, payment_method = nil)
      payment_method ||= order.payment_method_to_forward
      order.store.store_payment_methods.where(payment_method_id: payment_method.id).first.try(:account_parameters)
    end

    def store_payment_account_id(order, payment_method = nil)
      payment_method ||= order.payment_method_to_forward
      params = store_payment_account_parameters(order, payment_method)
      params.is_a?(Hash) ? params[:id] : params.to_s
    end
  end
end