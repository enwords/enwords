class Sentence < ApplicationRecord
  class CreateTranslation < ActiveInteraction::Base
    private

    object :sentence
    string :translation_lang

    def execute
      return unless translation_value

      Link.find_or_create_by!(sentence: sentence, translation: translation)
      AttachToWords.run!(sentence: translation)
      translation
    end

    def translation_value
      @translation_value ||= Yandex::Translate.run!(from: sentence.language, to: translation_lang, text: sentence.value)
    end

    def translation
      @translation ||= begin
        result = Sentence.find_or_initialize_by(language: translation_lang, value: translation_value)
        result.id ||= Sentence.last.id.next
        result.save!
        result
      end
    end
  end
end
