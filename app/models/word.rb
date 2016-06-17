class Word < ApplicationRecord
  has_many :wordbooks
  has_and_belongs_to_many :collections
  has_and_belongs_to_many :sentences
  has_and_belongs_to_many :users
  belongs_to :language
end
