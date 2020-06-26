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

    def word_mnemo
      return @word_mnemo if defined? @word_mnemo

      @word_mnemo = word.mnemos.sample.try(:value)
    end

    def word_translation
      @word_translation ||= word_translation_hash.dig('translation', 'text')
    end

    def word_transcription
      @word_transcription ||= word_translation_hash['transcription'] || word.transcription
    end

    def word_translation_hash
      @word_translation_hash ||=
        begin
          result = skyeng_translate if word.language == 'eng' && translation_lang.to_s == 'rus'
          result = yandex_translate if result.blank?
          result
        rescue StandardError
          {}
        end
    end

    def skyeng_translate
      Api::Skyeng.first_meaning(word: word.value)
    end

    def yandex_translate
      from = User::Languages::LOCALES[word.language.to_sym]
      to = User::Languages::LOCALES[translation_lang.to_sym]
      trans = Api::YandexTranslate.translate(text: word.value, from: from, to: to)
      {
        'translation' => { 'text' => trans },
        'text' => word.value
      }
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
        .select('sentences.value, translations_sentences.value translation, RANDOM()')
        .order('RANDOM()')
        .first
    end

    def sentence_without_translation
      Sentence
        .joins(<<~SQL)
          JOIN sentences_words
          ON sentences.id = sentences_words.sentence_id
          AND sentences_words.word_id = #{word.id}
        SQL
        .distinct
        .select('sentences.*, RANDOM()')
        .order('RANDOM()')
        .first
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
