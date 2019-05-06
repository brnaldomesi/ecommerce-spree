module Spree
  User.class_eval do
    USERNAME_REGEXP = /\A[a-z][a-z0-9_\-]*\z/i

    validates_format_of :username, with: USERNAME_REGEXP, allow_blank: true

    has_one :store, class_name: 'Spree::Store', foreign_key: 'user_id'

    before_save :set_defaults
    after_create :create_store

    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value', { :value => login.downcase }]).first
      elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_h).first
      end
    end


    def create_store
      ::Spree::Store.find_or_create_by(user_id: id) do|store|
        store.name = display_name || username || "Store #{id}"
        store.url = APP_HOST # ::SolidusMarket::Application.routes.url_helpers.seller_path(id: id)
        store.mail_from_address = email
        store.code = "sellers/#{id}"
      end
    end

    protected

    def set_defaults
      self.login = username if username.present?
    end
  end

end