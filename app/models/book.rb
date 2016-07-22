class Book < ApplicationRecord
  belongs_to :user
  has_many :wordbooks, dependent: :delete_all
  has_many :words, through: :wordbooks
end
