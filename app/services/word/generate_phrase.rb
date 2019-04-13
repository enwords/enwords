class Word < ApplicationRecord
  class GeneratePhrase < ActiveInteraction::Base
    private

    string :pos_j, default: -> { rand_word(:j) }
    string :pos_n, default: -> { rand_word(:n) }

    def execute
      [pos_j, pos_n].join(' ')
    end

    def rand_word(pos)
      words = Word.where(language: 'eng', pos: pos)
      offset = rand(words.count - 1)
      words.offset(offset).first.value.titleize
    end
  end
end
