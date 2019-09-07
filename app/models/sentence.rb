class Sentence < ApplicationRecord
  has_many :sentences_words
  has_many :links, foreign_key: :sentence_1_id
  has_many :words, through: :sentences_words
  has_many :translations, through: :links, source: :translation
end
