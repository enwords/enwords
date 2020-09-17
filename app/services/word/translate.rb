class Word < ApplicationRecord
  class Translate < ActiveInteraction::Base
    string :from
    string :to
    string :text

    def execute
      unless word
        tr = yandex_translate
        return tr ? { translation: tr, text: text, youglish: youglish, sound_url: sound_url } : nil
      end

      translation =
        word.data&.dig('trans', to) ||
        yandex_translate ||
        skyeng_translate&.dig('translation', 'text')
      {
        translation: translation,
        transcription: word.transcription || skyeng_translate&.dig('transcription'),
        text: word.value,
        sound_url: sound_url,
        youglish: youglish
      }
    end

    def sound_url
      ENV['ENG_SOUND_URL'] + word_value if from == 'eng'
    end

    def youglish
      accent = Rails.configuration.languages['locales'][from]
      return unless accent

      lang = Rails.configuration.languages['youglish'][accent]
      return unless lang

      {
        accent: accent,
        lang: lang
      }
    end

    def word_value
      @word_value ||= text.downcase.strip
    end

    def skyeng_translate
      return @skyeng_translate if defined? @skyeng_translate

      @skyeng_translate = begin
        return unless from == 'eng' && to == 'rus'

        result = API::Skyeng.first_meaning(word: word_value)
        return if result.blank?

        update_trans(result.dig('translation', 'text'))
        update_transcription(result.dig('transcription'))
        result
      end
    end

    def yandex_translate
      @yandex_translate ||= begin
        result = Yandex::Translate.run!(text: word_value, from: from, to: to)
        update_trans(result)
        result
      end
    end

    def update_trans(trans)
      return unless word && trans
      return if word.data&.dig('trans', to)

      data = word.data || {}
      data['trans'] ||= {}
      data['trans'][to] = trans
      word.update!(data: data)
    end

    def update_transcription(transcription)
      return unless word && transcription
      return if word.transcription

      word.update!(transcription: transcription)
    end

    def word
      @word ||= Word.find_by(language: from, value: word_value)
    end
  end
end
