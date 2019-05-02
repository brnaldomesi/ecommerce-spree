module ControllerHelpers
  module PageFlow

    def redirect_to_parameters(*page_params)
      session[:original_uri].blank? ? page_params : session[:original_uri]
    end

    def redirect_back(*page_params)
      redirect_to( redirect_to_parameters(page_params) )
    end

    def set_this_as_redirect_back(override = true)
      if override || session[:original_uri].blank?
        session[:original_uri] = request.url
      end
    end

    def set_referer_as_redirect_back(override = true)
      if override || session[:original_uri].blank?
        session[:original_uri] = request.referer
      end
    end

    def clear_redirect_back
      original = session[:original_uri]
      session[:original_uri] = nil
      original
    end

  end
end