module Yandex
  class Translate < ActiveInteraction::Base
    private

    CONFIG = {
      iam_token_cache_key: ENV['YANDEX_IAM_TOKEN_CACHE_KEY'],
      iam_token_url: ENV['YANDEX_IAM_TOKEN_URL'],
      api_url: ENV['YANDEX_API_URL'],
      oauth_token: ENV['YANDEX_OAUTH_TOKEN'],
      folder_id: ENV['YANDEX_FOLDER_ID']
    }.freeze

    string :from
    string :to
    string :text

    def execute
      request_params = {
        folderId: CONFIG[:folder_id],
        sourceLanguageCode: Rails.configuration.languages['locales'][from] || from,
        targetLanguageCode: Rails.configuration.languages['locales'][to] || to,
        texts: [text]
      }
      token = iam_token
      result = Curl.post(CONFIG[:api_url], request_params.to_json) do |curl|
        curl.headers['Content-Type'] = 'application/json'
        curl.headers['Accept'] = 'application/json'
        curl.headers['Authorization'] = "Bearer #{token}"
      end
      JSON.parse(result.body).dig('translations', 0, 'text')
    end

    def iam_token
      result = Rails.cache.read(CONFIG[:iam_token_cache_key])
      return result if result

      request_params = { yandexPassportOauthToken: CONFIG[:oauth_token] }
      response = Curl.post(CONFIG[:iam_token_url], request_params.to_json) do |curl|
        curl.headers['Content-Type'] = 'application/json'
        curl.headers['Accept'] = 'application/json'
      end
      parsed_response = JSON.parse(response.body)
      result = parsed_response['iamToken']
      expires_at = Time.parse(parsed_response['expiresAt'])
      Rails.cache.write(CONFIG[:iam_token_cache_key], result, expires_in: (expires_at.to_f - Time.current.to_f).seconds)
      result
    end
  end
end
