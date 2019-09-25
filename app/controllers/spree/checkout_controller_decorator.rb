::Spree::CheckoutController.class_eval do

  helper Spree::CheckoutHelperExtension

  def update
    order_update = ::Spree::OrderUpdateAttributes.new(@order, update_params, request_env: request.headers.env)
    logger.info "| order_update: #{order_update}"
    logger.info "| update_params: #{update_params.as_json}"
    # logger.info "| request: #{request.headers.env}" # this is be huge data to show

    if update_order

      assign_temp_address
      logger.info "  after update_order: #{@order.attributes}"
      logger.info "  can_complete? #{@order.can_complete?}"
      logger.info "  payments: #{@order.payments.all.collect(&:attributes)}"

      unless transition_forward
        redirect_on_failure
        return
      end
      logger.info "  completed? #{@order.completed?}"
      if @order.completed?
        finalize_order
      else
        logger.info "-> next: #{checkout_state_path(@order.state) }"
        send_to_next_state
      end

    else
      logger.warn "** Canoot update order: #{flash[:error] || flash[:notice]}, order #{@order.errors.full_messages}"
      render :edit
    end
  end

  protected

  ##
  # This replaces app's own routes method, and auto adds order_id: @order.id,
  # so @order or params[:order_id] is expected.
  def checkout_state_path(order_state)
    spree.checkout_state_path(order_state, order_id: @order.try(:id) || params[:order_id] )
  end

  private


end