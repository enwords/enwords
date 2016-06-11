class UsersWords < ActiveRecord::Base
  validates :word, uniqueness: {scope: :user}
end