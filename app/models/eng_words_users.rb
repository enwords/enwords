class EngWordsUsers < ActiveRecord::Base
  # belongs_to :user
  # belongs_to :eng_word
  validates :eng_word, uniqueness: {scope: :user}
end