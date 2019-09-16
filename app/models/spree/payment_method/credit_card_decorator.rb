::Spree::PaymentMethod::CreditCard.class_eval do

  def gateway_class
    # TODO:
  end

  def account_reference_label
    I18n.t('spree.card_number')
  end
end