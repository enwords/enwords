module Api
  module YandexTranslate
    API_URL = 'https://translate.yandex.net/api/v1.5/tr.json/translate'.freeze
    API_KEY = ENV['YANDEX_TRANSLATE']

    module_function

    def translate(text:, from:, to:)
      args = {
        text: text,
        lang: "#{from}-#{to}",
        key: API_KEY
      }
      result = Curl.post(API_URL + '?' + args.to_param)
      JSON.parse(result.body).dig('text', 0)
    end
  end
end
