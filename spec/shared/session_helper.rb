module SessionHelper

  def post(uri, params = {}, env = {}, &block)
    page.driver.browser.post(uri, params, env, &block)
  end
end