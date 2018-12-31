class Word < ApplicationRecord
  has_many :word_statuses

  has_many :sentences_words

  has_many :users,
           through: :word_statuses

  has_many :articles,
           through: :word_in_articles

  has_many :sentences,
           through: :sentences_words
end
