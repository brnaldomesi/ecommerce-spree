class CleanAndPopulatePaymentMethods < ActiveRecord::Migration[5.2]
  def change
    ::Spree::PaymentMethod.delete_all

    ::Spree::PaymentMethod::PayPal.create(
      name: 'PayPal', description:'Pay with PayPal', active: true, position: 1, available_to_users: true)
    ::Spree::PaymentMethod::CreditCard.create(
      name: 'Credit Card, Visa/MasterCard', description:'Pay with credit cards like Visa or MasterCard',
      active: true, position: 2, available_to_users: true)
    ::Spree::PaymentMethod::ApplePay.create(
        name: 'Apple Pay', description:'Pay with ApplePay',
        active: true, position: 3, available_to_users: true)
    ::Spree::PaymentMethod::GooglePay.create(
        name: 'Google Pay', description:'Pay with GooglePay',
        active: true, position: 4, available_to_users: true)
  end
end
