class TrainingSentence < ApplicationRecord
  belongs_to :user
  belongs_to :sentence
end