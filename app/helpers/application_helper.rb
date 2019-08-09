module ApplicationHelper

  def current_store
    nil
  end

  def default_title
    'Shoppn'
  end

  def title
    ''
  end

  def order_in_cart
    @order ||= Spree::Order.incomplete.find_or_initialize_by(guest_token: cookies.signed[:guest_token])
  end
end
