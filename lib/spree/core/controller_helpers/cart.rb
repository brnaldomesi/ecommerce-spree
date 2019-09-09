module Spree
  module Core
    module ControllerHelpers
      module Cart
        extend ActiveSupport::Concern

        def cart_items
          @cart_items ||= load_orders.to_a.collect(&:line_items).flatten
        end

        #
        # From spree/orders_controller.rb#edit
        def load_orders
          logger.info "| load_cart: request=#{request.method}"
          if %w|GET PATCH|.include?(request.method)
            unless @orders
              @orders = Spree::Order.includes(:store).incomplete.where(guest_token: cookies.signed[:guest_token])
              authorize! :read, @orders.first, cookies.signed[:guest_token] if @orders.first
              @orders.each do|order| # do what associate_user does
                order.associate_user!(try_spree_current_user) if order.user.blank? || order.email.blank?
              end
            end
          end
          @orders
        end
      end
    end
  end
end