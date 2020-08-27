module Yandex::Kassa
  class CreatePayment < Base
    private

    object :user, class: User
    integer :amount_cents
    string :currency

    def execute
      return unless response.response_code.in?([200, 201])

      payment.status = response_body['status']
      payment.data = [response_body]
      payment.save!
      payment
    end

    def return_url
      Rails.application.routes.url_helpers.after_checkout_subscriptions_url(payment_id: id, locale: I18n.locale)
    end

    def request_url
      CONFIG[:api_url] + '/payments'
    end

    def request_params
      {
        amount: {
          value: amount_cents / 100.0,
          currency: currency
        },
        capture: true,
        confirmation: {
          type: :redirect,
          return_url: return_url
        },
        description: "Order: #{id}"
      }
    end

    def response
      @response ||= Curl.post(request_url, request_params.to_json) do |curl|
        curl.headers['Content-Type'] = 'application/json'
        curl.headers['Accept'] = 'application/json'
        curl.headers['Authorization'] = authorization
        curl.headers['Idempotence-Key'] = id
      end
    end

    def id
      @id ||= SecureRandom.uuid
    end

    def payment
      @payment ||= Payment.new(
        id: id,
        amount_cents: amount_cents,
        currency: currency,
        user: user,
        provider: :yandex
      )
    end
  end
end
