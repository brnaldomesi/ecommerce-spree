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
        _store_id = store_id
        ::Spree::User.logger.debug "| ByParameters: store_id #{_store_id}"
        store = _store_id ? ::Spree::Store.where(id: _store_id).first : nil
        store || Spree::Store.new
      end

      private

      # Those actions that loads actions like /stores/:id
      LOAD_STORE_ACTIONS = %w|show edit update destroy|
      LOAD_STORE_CONTROLLERS = %w|spree/stores|

      def params
        @request.try(:params) || {}
      end

      def store_id
        _store_id = params[:store_id]
        unless _store_id
          if LOAD_STORE_CONTROLLERS.include?(params[:controller]) && LOAD_STORE_ACTIONS.include?(params[:action])
            _store_id = params[:id]
          end
        end
        _store_id
      end
    end
  end
end