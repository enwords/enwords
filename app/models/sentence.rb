class Sentence < ApplicationRecord
  belongs_to :training
  has_and_belongs_to_many :words
  has_one :audio
  has_and_belongs_to_many :translations,
                          class_name: "Sentence",
                          join_table: "links",
                          foreign_key: "sentence_1_id",
                          association_foreign_key: "sentence_2_id"
end
