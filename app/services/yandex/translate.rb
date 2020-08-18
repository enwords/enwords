module Yandex
  class Translate < ActiveInteraction::Base
    private

    CONFIG = {
      iam_token_cache_key: ENV['YANDEX_IAM_TOKEN_CACHE_KEY'],
      iam_token_url: ENV['YANDEX_IAM_TOKEN_URL'],
      api_url: ENV['YANDEX_API_URL'],
      oauth_token: ENV['YANDEX_OAUTH_TOKEN'],
      folder_id: ENV['YANDEX_FOLDER_ID']
    }

    string :from
    string :to
    string :text

    def execute
      request_params = {
        folderId: CONFIG[:folder_id],
        sourceLanguageCode: User::Languages::LOCALES[from.to_sym] || from,
        targetLanguageCode: User::Languages::LOCALES[to.to_sym] || to,
        texts: [text]
      }
      result = Curl.post(CONFIG[:api_url], request_params.to_json) do |curl|
        curl.headers['Content-Type'] = 'application/json'
        curl.headers['Accept'] = 'application/json'
        curl.headers['Authorization'] = "Bearer #{iam_token}"
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
      expires_at = parsed_response['expiresAt']
      Rails.cache.write(CONFIG[:iam_token_cache_key], result, expires_at: expires_at)
      result
    end
  end
end
