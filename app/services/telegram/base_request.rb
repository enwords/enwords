module Telegram
  class BaseRequest < ActiveInteraction::Base
    URL = "https://api.telegram.org/bot#{ENV['TELEGRAM_BOT_KEY']}".freeze

    def response(path, options = {})
      result = Curl.post(URL + '/' + path, options) do |curl|
        curl.proxy_tunnel = true
        curl.proxy_url = ENV['PROXY_URL']
        curl.proxypwd = ENV['PROXY_PWD']
      end
      JSON.parse(result.body).deep_symbolize_keys
    end
  end
end
