class Sentence < ApplicationRecord
  class ByWord < ActiveInteraction::Base
    object :word
    string :trans_lang

    def execute
      OpenStruct.new(
        sentence:    sentence.try(:sentence),
        translation: translation,
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
        .try(:sentence)
    end

    def text
      return unless sentence.try(:sentence)

      <<~HEREDOC
        #{sentence.try(:sentence)}
        * * *
        #{translation}
        * * *
        #{word.mnemos.map(&:content).join("\n")}
      HEREDOC
    end
  end
end
