module Spree
  module PaymentMethodsHelper

    def payment_methods_select_options
      options_from_collection_for_select(@available_payment_methods, 'id', 'name')
    end
  end
end