module Api
  module Skyeng
    class << self
      def send_token(email:)
        build_get_response('https://words.skyeng.ru/api/public/v1/users/token',
                           email: email)
      end

      def learning_word_ids(email:, token:)
        result = build_get_response('https://words.skyeng.ru/api/public/v1/users/meanings',
                                    email: email,
                                    token: token)

        return :invalid_params unless result.is_a?(Array)
        result.map { |el| el['meaningId'] }
      end

      def words(ids:)
        threads = []
        result  = []

        ids.each_slice(100) do |sliced_ids|
          threads << Thread.new do
            result << build_get_response('http://dictionary.skyeng.ru/api/public/v1/meanings',
                                         ids: sliced_ids.join(','))
          end
        end

        threads.each(&:join)
        result.flatten.flat_map { |i| i['text'].split }.uniq
      end

      def learning_words(email:, token:)
        ids = learning_word_ids(email: email, token: token)
        return [] unless ids.is_a?(Array)
        words(ids: ids)
      end

      def first_meaning(word:)
        result = build_get_response('http://dictionary.skyeng.ru/api/public/v1/words/search',
                                    search: word)

        return :invalid_params unless result.is_a?(Array)
        return {} if result.blank?

        meanings = result.dig(0, 'meanings').sort_by { |el| el['id'] }
        meanings[0].merge('text' => result.dig(0, 'text'))
      end

      def build_get_response(url, params = {})
        uri       = URI(url)
        uri.query = URI.encode_www_form(params)
        response  = Net::HTTP.get_response(uri)

        return :ok unless response.body
        JSON.parse(response.body)
      rescue
        :fail
      end
    end
  end
end
