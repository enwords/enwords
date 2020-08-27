class API::Web::PaymentsController < ::API::BaseController
  def callback
    PaymentCallback.create!(data: params)
    head :ok
  end
end
