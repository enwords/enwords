class UserAuthentication < ApplicationRecord
  belongs_to :user

  serialize :params

  enum provider: {
    facebook: 1,
    twitter: 2,
    vkontakte: 3,
    google: 4,
    google_oauth2: 5
  }, _prefix: :provider
end
