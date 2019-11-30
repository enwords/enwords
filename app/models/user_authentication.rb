class UserAuthentication < ApplicationRecord
  belongs_to :user
  belongs_to :authentication_provider

  serialize :params

  enum provider: {
    facebook: 1,
    twitter: 2,
    vkontakte: 3,
    google: 4,
    google_oauth2: 5
  }, _prefix: :provider

  def self.create_from_omniauth(params, user, auth_provider, provider)
    token_expires_at = if params.dig('credentials', 'expires_at')
                         Time.zone.at(params.dig('credentials', 'expires_at')).to_datetime
                       end
    create(
      user: user,
      authentication_provider: auth_provider,
      provider: provider,
      uid: params['uid'],
      token: params.dig('credentials', 'token'),
      token_expires_at: token_expires_at,
      params: params
    )
  end
end
