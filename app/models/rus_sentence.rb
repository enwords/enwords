class RusSentence < ApplicationRecord
  has_and_belongs_to_many :eng_sentences
end
