module Yandex::Kassa
  class CheckPayment < Base
    private

    object :payment, class: Payment

    def execute
      return payment unless payment.status_pending?
      return unless response.response_code.in?([200, 201])

      payment.status = response_body['status']
      payment.data << response_body
      payment.save!
      payment
    end

    def request_url
      CONFIG[:api_url] + "/payments/#{payment.data.first['id']}"
    end

    def response
      @response ||= Curl.get(request_url) do |curl|
        curl.headers['Content-Type'] = 'application/json'
        curl.headers['Accept'] = 'application/json'
        curl.headers['Authorization'] = authorization
      end
    end
  end
end
