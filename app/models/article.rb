class Article < ApplicationRecord
  belongs_to :user
  has_many :word_in_articles, dependent: :delete_all
  has_many :words, through: :word_in_articles
end
