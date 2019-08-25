class Sentence < ApplicationRecord
  class ByWord < ActiveInteraction::Base
    private

    object :word
    string :trans_lang

    def execute
      OpenStruct.new(
        word: word.value,
        sentence: sentence.try(:value),
        word_translation: word_translation,
        sentence_translation: sentence_translation,
        menemo: word_mnemo,
        text: text
      )
    end

    def sentence
      @sentence ||= word.sentences.left_joins(:translations).where(translations_sentences: { language: trans_lang }).sample
    end

    def sentence_translation
      @sentence_translation ||= sentence.translations.where(language: trans_lang).first.try(:value)
    end

    def skyeng_hash
      @skyeng_hash ||= Api::Skyeng.first_meaning(word: word.value) || {} rescue {}
    end

    def word_translation
      skyeng_hash.dig('translation', 'text') || ''
    end

    def word_transcription
      skyeng_hash['transcription']
    end

    def word_mnemo
      @word_mnemo ||= word.mnemos.first.try(:value)
    end

    def text
      return unless sentence.try(:value)

      result = ''
      result << word.value
      result << ' '
      result << "[#{word_transcription}] " if word_transcription.present?
      result << '- '
      result << word_translation
      result << "\n"
      result << "\n"
      result << sentence.value

      if sentence_translation.present?
        result << "\n"
        result << "-"
        result << "\n"
        result << sentence_translation
      end

      if word_mnemo.present?
        result << "\n"
        result << "\n"
        result << word_mnemo
      end

      result
    end
  end
end
