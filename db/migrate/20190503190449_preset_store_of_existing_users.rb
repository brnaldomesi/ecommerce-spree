class PresetStoreOfExistingUsers < ActiveRecord::Migration[5.2]
  def change
    Spree::User.all.each do|u|
      next if u.spree_roles.collect(&:name).include?('admin')
      puts [u.id, u.username, u.display_name].compact.join(' | ')
      u.create_store
    end
  end
end
