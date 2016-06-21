class Training < ApplicationRecord
  belongs_to :user
  belongs_to :sentence
  validates :sentence, uniqueness: {scope: :user}
end