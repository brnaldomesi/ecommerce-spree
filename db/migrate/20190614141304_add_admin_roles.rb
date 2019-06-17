class AddAdminRoles < ActiveRecord::Migration[5.2]
  def change
    admin_user = Spree::User.where(email: ['admin@tbdmarket.com', 'admin@example.com'] ).first
    admin_user ||= Spree::User.where("email like 'admin@%'").first || Spree::User.first
    unless admin_user.admin?
      admin_user.username ||= 'admin'
      admin_user.spree_roles << ::Spree::Role.where(name: 'admin').first
      admin_user.save
    end
  end
end
