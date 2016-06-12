class Word < ApplicationRecord
  has_and_belongs_to_many :collections
  has_and_belongs_to_many :sentences
  has_and_belongs_to_many :users

end
