class Sentence < ApplicationRecord
  has_one :audio
  has_many :training_sentences, dependent: :delete_all
  has_many :users, through: :training_sentences
  has_and_belongs_to_many :words
  has_and_belongs_to_many :translations,
                          class_name:              'Sentence',
                          join_table:              'links',
                          foreign_key:             'sentence_1_id',
                          association_foreign_key: 'sentence_2_id'
end
