class EngSentence < ApplicationRecord
  has_and_belongs_to_many :eng_words
  has_and_belongs_to_many :rus_sentences
end
