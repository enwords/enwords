class AuthenticationProvider < ApplicationRecord
  has_many :users
  has_many :user_authentications
end
