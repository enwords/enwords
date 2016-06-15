class Sentence < ApplicationRecord
  has_many :words
  has_and_belongs_to_many :sentences
  belongs_to :language
end
