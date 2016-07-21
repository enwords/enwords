class Word < ApplicationRecord
  has_many :word_statuses
  has_many :users, through: :word_statuses
  has_and_belongs_to_many :books
  has_and_belongs_to_many :sentences
end
