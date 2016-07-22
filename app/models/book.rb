class Book < ApplicationRecord
  belongs_to :user
  has_many :wordbooks
  has_many :words, through: :wordbooks
end
