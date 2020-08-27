module Yandex::Kassa
  class Base < ActiveInteraction::Base
    protected

    CONFIG = {
      api_url: ENV['YANDEX_KASSA_API_URL'],
      api_key: ENV['YANDEX_KASSA_API_KEY'],
      shop_id: ENV['YANDEX_KASSA_SHOP_ID']
    }.freeze

    def authorization
      "Basic #{Base64.strict_encode64([CONFIG[:shop_id], ':', CONFIG[:api_key]].join.strip)}"
    end

    def response_body
      JSON.parse(response.body)
    end
  end
end
