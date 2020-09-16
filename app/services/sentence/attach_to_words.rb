class Sentence < ApplicationRecord
  class AttachToWords < ActiveInteraction::Base
    private

    object :sentence

    def execute
      word_values = sentence.value.downcase.gsub(/[[:punct:]\d\+\$\^\=\-\>\<\~\`]/, '').split(' ').uniq
      words = Word.where(value: word_values, language: sentence.language)
      words.each { |word| SentencesWord.find_or_create_by!(sentence: sentence, word: word) }
    end
  end
end
