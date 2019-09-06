::Spree::CheckoutController.class_eval do

  protected

  ##
  # This replaces app's own routes method, and auto adds order_id: @order.id,
  # so @order or params[:order_id] is expected.
  def checkout_state_path(order_state)
    spree.checkout_state_path(order_state, order_id: @order.try(:id) || params[:order_id] )
  end

  # The actions with left over without call root path like spree.checkout_state_path
  #   insufficient_stock_error

end