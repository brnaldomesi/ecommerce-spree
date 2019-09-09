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

  def orders_in_cart
    @orders
  end

  def cart_items
    @cart_items ||= @orders.collect(&:line_items).flatten
  end
end
