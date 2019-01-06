class Word < ApplicationRecord
  class FromSentence < ActiveInteraction::Base
    object :user
    integer :sentence_id

    def execute
      words_from_sentence.map do |word|
        {
          id:      word.id,
          word:    word.value,
          learned: learned?(word)
        }
      end.as_json
    end

    private

    def sentence
      @_sentence ||= Sentence.find(sentence_id)
    end

    def words_from_sentence
      @_words_from_sentence ||=
        sentence.words.map { |word| word if available_words.include? word }.compact
    end

    def available_words
      @_available_words ||= Word::ByStatus.run!(status: 'available', user: user)
    end

    def learning_words
      @_learning_words ||= Word::ByStatus.run!(status: 'learning', user: user)
    end

    def learned_words
      @_learned_words ||= Word::ByStatus.run!(status: 'learned', user: user)
    end

    def learned?(word)
      return true  if learned_words.include? word
      return false if learning_words.include? word
      nil
    end
  end
end
