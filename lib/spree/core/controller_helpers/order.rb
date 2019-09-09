##
# Need to set current seller of the order.

Spree::Core::ControllerHelpers::Order.module_eval do

  def current_order_params
    { currency: current_pricing_options.currency, guest_token: cookies.signed[:guest_token], store_id: params[:store_id] || current_store.id, user_id: try_spree_current_user.try(:id) }
  end

  # The current incomplete order from the guest_token for use in cart and during checkout.
  # From core/lib/spree/core/controller_helpers/order.rb
  def current_order(options = {})
    options[:create_order_if_necessary] ||= false

    return @current_order if @current_order

    @current_order = ::Spree::Order.find(params[:order_id]) if params[:order_id]
    @current_order ||= find_order_by_token_or_user(options)
    logger.debug "| current_order: #{@current_order}, w/ current_order_params #{current_order_params}"

    if options[:create_order_if_necessary] && (@current_order.nil? || @current_order.completed?)
      @current_order = Spree::Order.new(new_order_params)
      @current_order.user ||= try_spree_current_user
      # See issue https://github.com/spree/spree/issues/3346 for reasons why this line is here
      @current_order.created_by ||= try_spree_current_user
      @current_order.save!
    end

    if @current_order
      @current_order.record_ip_address(ip_address)
      return @current_order
    end
  end

  def load_order
    @order ||= ::Spree::Order.find(params[:order_id]) if params[:order_id]
    # logger.info "| load_order: #{@order}"
  end
end