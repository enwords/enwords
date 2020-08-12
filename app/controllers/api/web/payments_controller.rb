class API::Web::PaymentsController < ::API::BaseController
  def callback
    PaymentCallback.create!(data: params[:payment])
    head :ok
  end
end
