::Spree::Order.class_eval do

  ##
  # If +which_payment+ not given, would be latest payment w/ checkout state.
  def forward_to_process_payment?(which_payment = nil)
    which_payment ||= payments.checkout.last
    return false if which_payment.nil?

    which_payment.payment_method.is_a?(Spree::PaymentMethod::PayPal)
  end

  ##
  # @return <Spree::PaymentMethod>
  def payment_method_to_forward
    payments.checkout.last.try(:payment_method)
  end

  private

  def allow_cancel?
    return false unless (state == 'payment' || state == 'confirm' || completed? ) && state != 'canceled'
    shipment_state.nil? || %w{ready backorder pending}.include?(shipment_state)
  end

end