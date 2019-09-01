class Sentence < ApplicationRecord
  class ByWord < ActiveInteraction::Base
    private

    object :word
    symbol :translation_lang

    def execute
      word.update(transcription: word_transcription) if word_transcription.present? && word.transcription.blank?
      {
        word: word.value,
        sentence: sentence.try(:value),
        word_translation: word_translation,
        sentence_translation: sentence.try(:translation),
        menemo: word_mnemo,
        text: text
      }
    end

    def sentence
      return @sentence if defined? @sentence

      @sentence = sentence_with_translation || sentence_without_translation
    end

    def sentence_with_translation
      Sentence
        .joins(<<~SQL)
          JOIN sentences_words
          ON sentences.id = sentences_words.sentence_id
          AND sentences_words.word_id = #{word.id}
          JOIN links
          ON links.sentence_1_id = sentences.id
          JOIN sentences translations_sentences
          ON translations_sentences.id = links.sentence_2_id
          AND translations_sentences.language = '#{translation_lang}'
        SQL
        .distinct
        .select('sentences.value, translations_sentences.value translation')
        .sample
    end

    def sentence_without_translation
      Sentence
        .joins(<<~SQL)
          JOIN sentences_words
          ON sentences.id = sentences_words.sentence_id
          AND sentences_words.word_id = #{word.id}
        SQL
        .distinct
        .sample
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
      skyeng_hash['transcription'] || word.transcription
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

      if sentence.try(:translation).present?
        result << "\n"
        result << "_#{sentence.translation}_"
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
