::Spree::Order.class_eval do

  before_save :generate_transaction_code

  ###############################
  # Overrides

  def finalize!
    ::Jobs::OrderJob.perform_async(id)
    super
  end

  ###############################
  # New methods

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

  ##
  # 7-characters, alphanumeral.
  def self.random_transaction_code(id = nil)
    ( ( (id || rand(1000)) % 5) * 243 + rand(5987123654) ).to_s(36).rjust(7,'0').upcase
  end

  private

  def allow_cancel?
    return false unless (state == 'payment' || state == 'confirm' || completed? ) && state != 'canceled'
    shipment_state.nil? || %w{ready backorder pending}.include?(shipment_state)
  end

  def generate_transaction_code
    self.transaction_code = self.class.random_transaction_code(id) if transaction_code.blank?
  end

end