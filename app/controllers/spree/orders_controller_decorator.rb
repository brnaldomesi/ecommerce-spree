::Spree::OrdersController.class_eval do

  ##
  # JS refresh of cart navigation toolbar item w/ dropdown menu.
  def cart_link_dropdown
    respond_to do|format|
      format.js
    end
  end
end