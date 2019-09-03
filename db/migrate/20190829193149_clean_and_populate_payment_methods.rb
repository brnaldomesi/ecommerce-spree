class CleanAndPopulatePaymentMethods < ActiveRecord::Migration[5.2]
  def change
    ::Spree::PaymentMethod.delete_all

    ::Spree::PaymentMethod.populate_with_common_payment_methods
  end
end
