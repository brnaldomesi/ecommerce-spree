class PaymentNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_notifications do|t|
      t.text :params
      t.string :status, limit: 64
      t.integer :order_id
      t.string :transaction_code, limit: 255
      t.string :ip, limit: 64
      t.timestamps
    end
    add_index :payment_notifications, :order_id

    add_column :spree_orders, :transaction_code, :string, limit: 255
  end
end
