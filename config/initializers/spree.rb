# Configure Solidus Preferences
# See http://docs.solidus.io/Spree/AppConfiguration.html for details

Spree.config do |config|
  # Core:

  # Default currency for new sites
  config.currency = 'USD'

  # from address for transactional emails
  config.mails_from ='site@shoppn.com'

  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false

  # When set, product caches are only invalidated when they fall below or rise
  # above the inventory_cache_threshold that is set. Default is to invalidate cache on
  # any inventory changes.
  # config.inventory_cache_threshold = 3


  # Frontend:

  # Custom logo for the frontend
  config.logo = 'logo/shoppn-logo.png'

  # Template to use when rendering layout
  # config.layout = "spree/layouts/spree_application"


  # Admin:

  # Custom logo for the admin
  # config.admin_interface_logo = "logo/solidus.svg"

  # Gateway credentials can be configured statically here and referenced from
  # the admin. They can also be fully configured from the admin.
  #
  # config.static_model_preferences.add(
  #   Spree::Gateway::StripeGateway,
  #   'stripe_env_credentials',
  #   secret_key: ENV['STRIPE_SECRET_KEY'],
  #   publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  #   server: Rails.env.production? ? 'production' : 'test',
  #   test_mode: !Rails.env.production?
  # )
end

Spree::Frontend::Config.configure do |config|
  config.locale = 'en'
end

Spree::Backend::Config.configure do |config|
  config.locale = 'en'
end

Spree::Api::Config.configure do |config|
  config.requires_authentication = true
end

Spree.user_class = 'Spree::LegacyUser'

Spree::Config.roles.assign_permissions(:default, ['Spree::PermissionSets::SellerUser'] )
Spree::Config.generate_api_key_for_all_roles = true
Spree::Config[:require_master_price] = true
Spree::Config.current_store_selector_class = Spree::StoreSelector::ByParameters

Spree::Auth::Config[:confirmable] = true
Spree::Auth::Config.draw_frontend_routes = false

# Admin preferences
Spree::Config.preferences[:admin_products_per_page] = 30