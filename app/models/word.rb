class Word < ApplicationRecord
  has_many :word_statuses, dependent: :delete_all
  has_many :users, through: :word_statuses
  has_many :word_in_articles, dependent: :delete_all
  has_many :articles, through: :word_in_articles
  has_and_belongs_to_many :sentences
end
