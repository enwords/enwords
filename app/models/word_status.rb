class WordStatus < ApplicationRecord
  belongs_to :user
  belongs_to :word

  validates  :word, uniqueness: { scope: :user }
end
