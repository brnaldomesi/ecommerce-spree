module SessionHelper
  extend ActiveSupport::Concern

  included do
    [:post, :post_via_redirect, :patch, :follow_redirect!].each do|method|
      define_method method do|*args, &block|
        page.driver.browser.send(method, *args, &block)
      end
    end
  end

end