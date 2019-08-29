class Training < ApplicationRecord
  class Create < ActiveInteraction::Base
    string  :training_type
    object  :user
    integer :words_learned, default: 0
    array   :word_ids do
      Integer
    end

    set_callback(:type_check, :after, -> { self.word_ids = word_ids.map(&:to_i) })

    def execute
      ApplicationRecord.transaction do
        training.update!(
          type:          type,
          word_ids:      word_ids,
          words_learned: words_learned
        )

        case type
        when 'RepeatingTraining', 'SpellingTraining', 'GrammarTraining'
          training.update!(sentence_ids: sentence_ids)
        end
      end
    end

    private

    def training
      @_training ||= Training.where(user: user).first_or_initialize
    end

    def grouped_sentences_words
      SentencesWord
        .select("word_id, (array_agg(sentence_id order by random()))[1:#{user.sentences_number}] sentence_ids")
        .where(word_id: word_ids)
        .group(:word_id)
        .order(:word_id)
        .each_with_object({}) { |sw, hsh| hsh[sw.word_id] = sw.sentence_ids }
    end

    def grouped_sentences_words_with_translations
      result =
        SentencesWord
        .select("word_id, (array_agg(sentence_id order by random()))[1:#{user.sentences_number}] sentence_ids")
        .where(word_id: word_ids)
        .left_joins(sentence: :translations)
        .where(translations_sentences: { language: user.native_language })
        .group(:word_id)
        .order(:word_id)
        .each_with_object({}) { |sw, hsh| hsh[sw.word_id] = sw.sentence_ids }

      word_ids.map(&:to_i).each do |word_id|
        next if result[word_id].present?

        result[word_id] =
          SentencesWord
          .select("(array_agg(sentence_id))[1:#{user.sentences_number}] sentence_ids")
          .where(word_id: word_id)
          .order('random()')
          .first
          .sentence_ids
      end

      result
    end

    def sentence_ids
      result =
        if user.diversity_enable?
          grouped_sentences_words
        else
          grouped_sentences_words_with_translations
        end

      result.values.flatten.uniq
    end

    def type
      case training_type
      when 'repeating'  then 'RepeatingTraining'
      when 'spelling'   then 'SpellingTraining'
      when 'grammar'    then 'GrammarTraining'
      when 'mnemo'      then 'MnemoTraining'
      else raise 'wtf?'
      end
    end
  end
end
