module Spree
  User.class_eval do
    USERNAME_REGEXP = /\A[a-z][a-z0-9_\-]*\z/i

    validates_format_of :username, with: USERNAME_REGEXP, allow_blank: true

    attr_accessor :login

    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value', { :value => login.downcase }]).first
      elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_h).first
      end
    end
  end

end