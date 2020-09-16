class Word < ApplicationRecord
  class FromSentence < ActiveInteraction::Base
    object :user
    integer :sentence_id

    def execute
      Sentence::AttachToWords.run!(sentence: sentence)
      words_from_sentence.map do |word|
        {
          id: word.id,
          word: word.value,
          learned: word.learned
        }
      end.as_json
    end

    private

    def sentence
      @sentence ||= Sentence.find(sentence_id)
    end

    def words_from_sentence
      sentence
        .words
        .select('words.id, words.value, word_statuses.learned')
        .where(id: available_words.select(:id))
        .joins(<<~SQL)
          LEFT JOIN word_statuses
          ON word_statuses.word_id = words.id
          AND word_statuses.user_id = #{user.id}
        SQL
    end

    def available_words
      Word::ByStatus.run!(status: 'available', user: user)
    end
  end
end
