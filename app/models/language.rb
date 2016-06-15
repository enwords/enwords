class Language < ApplicationRecord
  has_many :words
  has_many :sentences
  has_many :users
end
