class EngWord < ApplicationRecord
  has_and_belongs_to_many :word_collections
  has_and_belongs_to_many :eng_sentences

end
