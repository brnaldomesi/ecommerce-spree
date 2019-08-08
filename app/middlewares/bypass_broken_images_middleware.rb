# From https://gist.github.com/mcmire/68cd9c74ba765a2d5dfb14abf58409aa
# Instructions
# ------------
#
# * Save this as app/middlewares/bypass_broken_images_middleware.rb
# * Add the following inside of the Rails.application.configure block
#   in config/environments/test.rb:
#
#     config.middleware.insert_before(
#       ActionDispatch::DebugExceptions,
#       BypassBrokenImagesMiddleware,
#     )
class BypassBrokenImagesMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.(env)
  rescue => error
    if unknown_path?(error) && request_for_image?(env)
      # nothing to see here, move along
      [404, {}, ""]
    else
      raise error
    end
  end

  private

  def unknown_path?(error)
    error.is_a?(ActionController::RoutingError)
  end

  def request_for_image?(env)
    env["PATH_INFO"] =~ %r{\A/(assets|images)/} ||
        env["PATH_INFO"] =~ /\.(jpg|jpeg|png)\Z/
  end
end