class PaymentNotification < ::ActiveRecord::Base
  serialize :params

  validates_presence_of :order_id, :params

  belongs_to :order, class_name: 'Spree::Order'

  after_create :parse_notification!

  def parse_notification!
    if order && (order.transaction_code.blank? || transaction_code == order.transaction_code)
      notification_hash = self.params.to_hash
      if status =~ /\Acompleted\Z/i # This is only for PayPal.  Change to more flexible
        order.payment_state = 'paid'
        order.payment_total = order.total
        order.complete!
      end
    end
  end

  private

end