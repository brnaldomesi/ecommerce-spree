::Spree::OrdersController.class_eval do
  include Spree::Core::ControllerHelpers::Cart

  skip_before_action :verify_authenticity_token, only: :cancel
  before_action :load_order_for_cancel, only: [:cancel]

  def cancel
    # authorize! :update, @order, cookies.signed[:guest_token]
    if can?(:update, @order) && @order.transaction_code.blank? || (params[:transaction_code] || params[:code] ) == @order.transaction_code
      logger.info "| Order #{@order.id}: state=#{@order.state}"
      @order.canceled_by(spree_current_user || @order.user)

      redirect_to order_path(number: @order.number)
    else
      unauthorized
    end
  end

  ##
  # Sets @current_store ahead based on variant. After that same as original method.
  def populate

    variant  = Spree::Variant.includes(:user).find(params[:variant_id])
    @current_store = variant.user.fetch_store
    @order = current_order(store_id: params[:store_id] || @current_store.id, create_order_if_necessary: true)
    authorize! :update, @order, cookies.signed[:guest_token]

    quantity = params[:quantity].present? ? params[:quantity].to_i : 1

    # 2,147,483,647 is crazy. See issue https://github.com/spree/spree/issues/2695.
    if !quantity.between?(1, 2_147_483_647)
      @order.errors.add(:base, t('spree.please_enter_reasonable_quantity'))
    end

    begin
      @line_item = @order.contents.add(variant, quantity)
    rescue ActiveRecord::RecordInvalid => e
      @order.errors.add(:base, e.record.errors.full_messages.join(', '))
    end

    respond_with(@order) do |format|
      format.html do
        if @order.errors.any?
          flash[:error] = @order.errors.full_messages.join(', ')
          redirect_back_or_default(spree.root_path)
          return
        else
          redirect_to cart_path
        end
      end
    end
  end

  ##
  # JS refresh of cart navigation toolbar item w/ dropdown menu.
  def cart_link_dropdown
    respond_to do|format|
      format.js
    end
  end

  def accurate_title
    if @order && @order.canceled?
      s = t('activerecord.attributes.spree/order.canceled_at') + " #{@order.canceled_at.to_s(:short)}"
      s << " by #{@order.canceler.display_name}" if @order.canceler
      s
    else
      super
    end
  end

  private

  def load_order_for_cancel
    assign_order
  end

  def assign_order
    logger.info "| order_id: #{params[:id]}"
    @order = params[:id] ? Spree::Order.find(params[:id]) : current_order
    logger.info "  -> @order #{@order}"
    unless @order
      flash[:error] = t('spree.order_not_found')
      redirect_to(root_path) && return
    end
    @order
  end
end