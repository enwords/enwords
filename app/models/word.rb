class Word < ApplicationRecord
  has_many :word_statuses
  has_many :users, through: :word_statuses
  has_many :wordbooks
  has_many :books, through: :wordbooks
  has_and_belongs_to_many :sentences
end
