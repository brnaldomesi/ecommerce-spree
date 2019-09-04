# Override of ByServerName set at default at Spree::Config.current_store_selector_class.
# This looks at params (which include :controller and :action).
module Spree
  module StoreSelector
    class ByParameters

      def initialize(request)
        @request = request
      end

      # Chooses the current store based on a request.
      # @return [Spree::Store]
      def store
        store_id = store_id
        ::Spree::User.logger.info "| ByParameters: store_id #{store_id}"
        store = store_id ? ::Spree::Store.where(id: store_id).first : nil
        store || Spree::Store.new
      end

      private

      # Those actions that loads actions like /stores/:id
      LOAD_STORE_ACTIONS = %w|show edit update destroy|
      LOAD_STORE_CONTROLLERS = %w|spree/stores|

      def store_id
        store_id = params[:store_id]
        unless store_id
          if LOAD_STORE_CONTROLLERS.include?(params[:controller]) && LOAD_STORE_ACTIONS.include?(params[:action])
            store_id = params[:id]
          end
        end
        store_id
      end
    end
  end
end