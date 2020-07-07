module Payments::Paypal::Requests
  class GetAccessToken < Base
    REQUEST_URL = Rails.application.secrets[:paypal][:base_url] + '/v1/oauth2/token'

    option :paypal_cred
    option :cache_token_hash_key, default: -> { "paypal_access_token_hash_#{paypal_cred.id}" }

    def call
      return cached_token_hash['access_token'] if cached_token_hash.present? && cached_token_hash['access_token']

      response = Curl.post(REQUEST_URL, request_params.to_query) do |curl|
        curl.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        curl.headers['Accept'] = 'application/json'
        curl.headers['AUTHORIZATION'] = authorization
      end

      token_hash = parse_response(response)
      write_to_cache(token_hash)
      token_hash['access_token']
    end

    private

    def request_params
      {
        grant_type: :client_credentials
      }
    end

    def authorization
      auth = Base64.strict_encode64([paypal_cred.client_id, ':', paypal_cred.secret].join.strip)
      "Basic #{auth}"
    end

    def write_to_cache(token_hash)
      Rails.cache.write(cache_token_hash_key, token_hash, expires_in: token_hash['expires_in'].seconds)
    end

    def cached_token_hash
      @cached_token_hash ||= Rails.cache.read(cache_token_hash_key)
    end
  end
end
