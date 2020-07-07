class API::Payments::WebhooksController < ::API::BaseController
  def paypal
    PaymentLog.create!(
      provider: :paypal,
      payment_type: :subscription,
      data: params
    )
    head :ok
  end
end
