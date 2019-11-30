class User < ApplicationRecord
  class CreateFromOmniauth < ActiveInteraction::Base
    object :auth_params, class: OmniAuth::AuthHash
    object :user, default: nil

    def execute
      return authentication.user if authentication.present?

      user =
        if existing_user.present?
          existing_user
        else
          User.create!(email: email || fake_email, password: Devise.friendly_token)
        end

      UserAuthentication.create_from_omniauth(auth_params, user, provider, auth_params.provider)
      user
    end

    private

    def provider
      @provider ||= AuthenticationProvider.find_by(name: auth_params.provider)
    end

    def authentication
      @authentication ||=
        provider.user_authentications.find_by(uid: auth_params.uid)
    end

    def existing_user
      @existing_user ||= (user || User.find_by(email: email))
    end

    def email
      auth_params.dig('info', 'email')
    end

    def fake_email
      domain =
        case auth_params['provider']
        when 'vkontakte' then 'vk.com'
        else "#{auth_params['provider']}.com"
        end

      SecureRandom.hex(8) + '@' + domain
    end
  end
end
