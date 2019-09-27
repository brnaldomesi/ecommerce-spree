class PaymentNotificationsController < ::InheritedResources::Base

  load_and_authorize_resource

  skip_before_action :verify_authenticity_token, only: :log

  def log
    params.permit!

    PaymentNotification.create(params: params.to_hash, order_id: params[:order_id], status: params[:payment_status],
      transaction_code: params[:transaction_code] || params[:code], id: request.env['REMOTE_ADDR'] )

    redirect_to '/'
  end

end