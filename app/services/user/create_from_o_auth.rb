class User < ApplicationRecord
  class CreateFromOAuth < ActiveInteraction::Base
    object :params, class: OmniAuth::AuthHash
    object :user, default: nil

    def execute
      return auth.user if auth.present?

      user =
        if existing_user.present?
          existing_user
        else
          User.create!(email: email || fake_email, password: Devise.friendly_token)
        end

      create_auth(user)
      user
    end

    private

    def create_auth(user)
      token_expires_at = if params.dig('credentials', 'expires_at')
                           Time.zone.at(params.dig('credentials', 'expires_at')).to_datetime
                         end
      UserAuthentication.create(
        user: user,
        provider: params['provider'],
        uid: params['uid'],
        token: params.dig('credentials', 'token'),
        token_expires_at: token_expires_at,
        params: params
      )
    end

    def auth
      @auth ||= UserAuthentication.find_by(provider: params['provider'], uid: params['uid'])
    end

    def existing_user
      @existing_user ||= (user || User.find_by(email: email))
    end

    def email
      params.dig('info', 'email')
    end

    def fake_email
      domain =
        case params['provider']
        when 'vkontakte' then 'vk.com'
        else "#{params['provider']}.com"
        end
      Devise.friendly_token + '@' + domain
    end
  end
end
