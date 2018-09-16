class Sentence < ApplicationRecord
  class ByWord < ActiveInteraction::Base
    string :word
    string :language
    string :translation_language

    def execute
      OpenStruct.new(
        sentence:    sentence.try(:sentence),
        translation: translation,
        text:        text
      )
    end

    def sentence
      @_sentence ||=
        word_record
        .sentences
        .left_joins(:translations)
        .where(translations_sentences: { language: translation_language })
        .sample
    end

    def translation
      @_translation ||=
        sentence
        .translations
        .where(language: translation_language)
        .first
        .try(:sentence)
    end

    def word_record
      @_word_record ||= Word.find_by(word: word, language: language)
    end

    def text
      return unless sentence.try(:sentence)

      <<~HEREDOC
        #{sentence.try(:sentence)}
        * * *
        #{translation}
      HEREDOC
    end
  end
end
