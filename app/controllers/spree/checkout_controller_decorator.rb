::Spree::CheckoutController.class_eval do

  helper Spree::CheckoutHelperExtension

  ##
  # This replaces app's own routes method, and auto adds order_id: @order.id,
  # so @order or params[:order_id] is expected.
  def checkout_state_path(order_state)
    spree.checkout_state_path(order_state, order_id: @order.try(:id) || params[:order_id] )
  end

  private


end