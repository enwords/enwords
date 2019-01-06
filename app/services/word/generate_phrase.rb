class Word < ApplicationRecord
  class GeneratePhrase < ActiveInteraction::Base
    private

    array :poses, default: %i[j n]

    def execute
      poses.map { |pos| get_rand_word(pos: pos) }.join(' ')
    end

    def get_rand_word(pos:)
      words  = Word.where(language: 'eng', pos: pos)
      offset = rand(words.count - 1)
      words.offset(offset).first.value.titleize
    end
  end
end
