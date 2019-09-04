::Spree::OrdersController.class_eval do

  ##
  # The cart has changed to handle multi-seller orders.
  def edit
    @orders = Spree::Order.includes(:store).incomplete.where(guest_token: cookies.signed[:guest_token])
    if @orders.blank?
      @orders = []
    else
      authorize! :read, @orders.first, cookies.signed[:guest_token]

      @orders.each do|order| # do what associate_user does
        order.associate_user!(try_spree_current_user) if order.user.blank? || order.email.blank?
      end
    end
  end

  ##
  # Sets @current_store ahead based on variant. After that same as original method.
  def populate

    variant  = Spree::Variant.includes(:user).find(params[:variant_id])
    @current_store = variant.user.store
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

  private

  def assign_order
    @order = params[:id] ? Spree::Order.find(params[:id]) : current_order
    unless @order
      flash[:error] = t('spree.order_not_found')
      redirect_to(root_path) && return
    end
  end
end