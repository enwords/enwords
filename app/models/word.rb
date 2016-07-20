class Word < ApplicationRecord
  has_many :word_statuses
  has_many :users, through: :word_statuses
  belongs_to :collection
  has_and_belongs_to_many :sentences
end
