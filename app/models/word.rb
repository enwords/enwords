class Word < ApplicationRecord
  belongs_to :collection
  has_and_belongs_to_many :sentences
  belongs_to :user
  has_many :word_statuses
end
