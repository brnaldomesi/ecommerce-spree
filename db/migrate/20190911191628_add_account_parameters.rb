class AddAccountParameters < ActiveRecord::Migration[5.2]
  def up
    add_column :spree_store_payment_methods, :account_parameters, :string, length: 255, default: ''
    add_column :spree_store_payment_methods, :account_label, :string, length: 64, default: ''
  end

  def down
    remove_column :spree_store_payment_methods, :account_parameters
    remove_column :spree_store_payment_methods, :account_label
  end
end
