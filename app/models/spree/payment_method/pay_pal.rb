module Spree
  class PaymentMethod::PayPal < PaymentMethod
    def payment_source_class
      Spree::Gateway::PayPalGateway
    end

    def supports?(source)
      true
    end

    def source_required?
      false
    end

    def forward_payment_url

    end

  end
end