class User < ApplicationRecord
  class CreateFromOmniauth < ActiveInteraction::Base
    object :auth_params, class: OmniAuth::AuthHash
    object :user, default: nil

    def execute
      case
      when authentication.present?
        authentication.user
      when existing_user.present?
        UserAuthentication.create_from_omniauth \
          auth_params, existing_user, provider

        existing_user
      else
        user = User.create(email:    email || fake_email,
                           password: Devise.friendly_token)

        errors.add :user, user.errors.full_messages.first unless user.valid?
        UserAuthentication.create_from_omniauth(auth_params, user, provider)
        user
      end
    end

    private

    def provider
      @_provider ||= AuthenticationProvider.find_by(name: auth_params.provider)
    end

    def authentication
      @_authentication ||=
        provider.user_authentications.find_by(uid: auth_params.uid)
    end

    def existing_user
      @_existing_user ||= (user || User.find_by(email: email))
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
