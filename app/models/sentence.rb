class Sentence < ApplicationRecord
  has_and_belongs_to_many :trainings
  has_and_belongs_to_many :words
  belongs_to :language
  has_one :audio

  has_and_belongs_to_many(:sentences,
                          :join_table => "links",
                          :foreign_key => "sentence_1_id",
                          :association_foreign_key => "sentence_2_id")
end
