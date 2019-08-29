class Sentence < ApplicationRecord
  class ByWord < ActiveInteraction::Base
    private

    object :word
    string :trans_lang

    def execute
      {
        word: word.value,
        sentence: sentence.try(:value),
        word_translation: word_translation,
        sentence_translation: sentence_translation,
        menemo: word_mnemo,
        text: text
      }
    end

    def sentence
      @sentence ||=
        word.sentences.left_joins(:translations).where(translations_sentences: { language: trans_lang }).sample
    end

    def sentence_translation
      return unless sentence

      @sentence_translation ||= sentence.translations.where(language: trans_lang).first.try(:value)
    end

    def skyeng_hash
      @skyeng_hash ||= Api::Skyeng.first_meaning(word: word.value)
    rescue
      {}
    end

    def word_translation
      skyeng_hash.dig('translation', 'text')
    end

    def word_transcription
      skyeng_hash['transcription']
    end

    def word_mnemo
      @word_mnemo ||= word.mnemos.first.try(:value)
    end

    def text
      return unless sentence.try(:value)

      result = "*#{word.value}*"
      result << ' '
      result << "_[#{word_transcription}]_ " if word_transcription.present?

      if word_translation.present?
        result << '- '
        result << word_translation
      end

      result << "\n"
      result << "\n"
      result << sentence.value

      if sentence_translation.present?
        result << "\n"
        result << "_#{sentence_translation}_"
      end

      if word_mnemo.present?
        result << "\n"
        result << "\n"
        result << "_#{word_mnemo}_"
      end

      result
    end
  end
end
