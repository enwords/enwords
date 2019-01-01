class Training < ApplicationRecord
  class Create < ActiveInteraction::Base
    string  :training_type
    object  :user
    integer :words_learned, default: 0
    array   :word_ids do
      Integer
    end

    set_callback :type_check, :after, -> { self.word_ids = word_ids.map(&:to_i) }

    validate :check_training_type

    def execute
      training.update!(
        training_type: training_type,
        word_ids:      word_ids,
        sentence_ids:  sentence_ids,
        words_learned: words_learned
      )
    end

    private

    def training
      @_training ||= Training.where(user: user).first_or_initialize
    end

    def grouped_sentences_words
      SentencesWord.where(word_id: word_ids).group_by(&:word_id)
    end

    def grouped_sentences_words_with_translations
      result =
        SentencesWord
          .where(word_id: word_ids)
          .left_joins(sentence: :translations)
          .where(translations_sentences: { language: user.native_language })
          .group_by(&:word_id)

      word_ids.map(&:to_i).each do |word_id|
        next if result[word_id].present?

        result[word_id] = SentencesWord.where(word_id: word_id)
      end

      result
    end

    def select_random_sentence_ids(grouped_sentences_words)
      result = grouped_sentences_words.flat_map do |_word_id, sentences_words_array|
        sentences_words_array.map(&:sentence_id).sample(user.sentences_number)
      end

      result.uniq
    end

    def sentence_ids
      result =
        if user.diversity_enable?
          grouped_sentences_words
        else
          grouped_sentences_words_with_translations
        end

      select_random_sentence_ids(result)
    end

    # validations

    def check_training_type
      return if Training::TRAINING_TYPES.include? training_type
      errors.add :training, 'Unknown training type'
    end
  end
end
