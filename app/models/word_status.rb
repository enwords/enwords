class WordStatus < ActiveRecord::Base
  belongs_to :user
  belongs_to :word
  validates :word, uniqueness: {scope: :user}
end