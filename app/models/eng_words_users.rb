class EngWordsUsers < ActiveRecord::Base
  validates :eng_word, uniqueness: {scope: :user}
end