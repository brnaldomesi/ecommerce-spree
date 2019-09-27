Spree::Core::Engine.routes.draw do
  # solidus_auth_devise-master/config/routes.rb
  unless Spree::Auth::Config.draw_frontend_routes

    devise_for(:spree_user, {
        class_name: 'Spree::User',
        controllers: {
            sessions: 'spree/user_sessions',
            registrations: 'spree/user_registrations',
            passwords: 'spree/user_passwords',
            confirmations: 'spree/user_confirmations'
        },
        skip: [:unlocks, :omniauth_callbacks],
        path_names: { sign_in: 'login', sign_out: 'logout' },
        path: '/users'
    })

    resources :users, only: [:edit, :update]

    devise_scope :spree_user do
      get '/login', to: 'user_sessions#new', as: :login
      post '/login', to: 'user_sessions#create', as: :create_new_session
      match '/logout', to: 'user_sessions#destroy', as: :logout, via: Devise.sign_out_via
      get '/signup', to: 'user_registrations#new', as: :signup
      post '/signup', to: 'user_registrations#create', as: :registration
      get '/password/recover', to: 'user_passwords#new', as: :recover_password
      post '/password/recover', to: 'user_passwords#create', as: :reset_password
      get '/password/change', to: 'user_passwords#edit', as: :edit_password
      put '/password/change', to: 'user_passwords#update', as: :update_password
      get '/confirm', to: 'user_confirmations#show', as: :confirmation if Spree::Auth::Config[:confirmable]
    end

    get '/checkout/registration', to: 'checkout#registration', as: :checkout_registration
    put '/checkout/registration', to: 'checkout#update_registration', as: :update_checkout_registration

    resources :account, controller: 'users'

    match '/access' => 'users#access', as: 'user_access', via: [:get]
    match '/access_login' => 'users#access_login', as: 'user_access_login', via: [:put, :post]
  end

  ##
  # Admins
  match '/admin/products/:id/erase', to: 'admin/products#erase', as: 'admin_erase_product', via: [:delete]

  ##
  # Seller
  resources :store_payment_methods
  get '/accepted_payments', to: 'store_payment_methods#index', as: 'accepted_payments'

  ##
  # Buyer

  resources :variants

  # Trading
  get '/orders/:id/cancel', to: 'orders#cancel', as: 'order_cancel'


  get '/cart_link_dropdown', to: 'orders#cart_link_dropdown', as: 'cart_link_dropdown'

end

Rails.application.routes.draw do
  default_url_options :host => (Rails.env.production? ? 'shoppn.com' : 'localhost')

  # This line mounts Solidus's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Solidus relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/'

  #########################
  # Filtering bots
  get '/:a/:b.php', to: 'errors#not_found'
  get '/:a.php', to: 'errors#not_found'

  ####################################################
  # Admins

  resources :site_categories, path: 'admin/site_categories'

  ####################################################
  # Additions to Spree
  namespace :spree, path: '/' do
    resources :stores, only: [:show, :index]
  end

  ##
  # Users
  namespace :users do
    resources :resource_action, only: [:index, :create, :destroy]
  end

  # Buyers

  get '/sellers/:id', to: 'sellers#show', as: :seller

  # Payments
  match '/payment_notifications/log' => 'payment_notifications#log', via: [:get, :put, :post], as: 'log_payment_notification'
  resources :payment_notifications

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
