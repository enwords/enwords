class Sentence < ApplicationRecord
  class ByWord < ActiveInteraction::Base
    object :word
    string :trans_lang

    def execute
      OpenStruct.new(
        sentence:    sentence.try(:value),
        translation: translation.try(:value),
        text:        text
      )
    end

    def sentence
      @_sentence ||=
        word
        .sentences
        .left_joins(:translations)
        .where(translations_sentences: { language: trans_lang })
        .sample
    end

    def translation
      @_translation ||=
        sentence
        .translations
        .where(language: trans_lang)
        .first
    end

    def text
      return unless sentence.try(:value)

      <<~HEREDOC
        #{sentence.try(:value)}
        * * *
        #{translation.try(:value)}
        * * *
        #{word.mnemos.map(&:value).join("\n")}
      HEREDOC
    end
  end
end
