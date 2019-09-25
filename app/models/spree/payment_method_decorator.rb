Spree::PaymentMethod.class_eval do
  def self.populate_with_common_payment_methods
    ::Spree::PaymentMethod::PayPal.find_or_create_by(name: 'PayPal') do|pm|
      pm.description ='Pay with PayPal'
      pm.active = true
      pm.position = 1
      pm.available_to_users = true
    end
    ::Spree::PaymentMethod::CreditCard.find_or_create_by(name: 'Credit Card, Visa/MasterCard') do|pm|
      pm.description = 'Pay with credit cards like Visa or MasterCard'
      pm.active = true
      pm.position = 2
      pm.available_to_users = true
    end
    ::Spree::PaymentMethod::ApplePay.find_or_create_by(name: 'Apple Pay') do|pm|
      pm.description = 'Pay with ApplePay'
      pm.active = true
      pm.position = 3
      pm.available_to_users = true
    end
    ::Spree::PaymentMethod::GooglePay.find_or_create_by(name: 'Google Pay') do|pm|
      pm.description = 'Pay with GooglePay'
      pm.active = true
      pm.position = 4
      pm.available_to_users = true
    end
  end

  ##
  # Depending on payment method type, the attribute name that payer can refer to during payments;
  # for example, credit card needs 'card number' while PayPal simply needs 'Account ID'.
  def account_reference_label
    I18n.t('spree.account_id')
  end

  def forward_payment_url
    nil
  end
end