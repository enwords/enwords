class Article < ApplicationRecord
  belongs_to :user
  has_many :word_in_articles, dependent: :delete_all
  has_many :words, through: :word_in_articles

  validates :user, presence: true
  validates :language, presence: true
  validates :title, presence: true
  validates :content, presence: true
end
