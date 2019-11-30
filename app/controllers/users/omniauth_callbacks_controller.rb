class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  %w[facebook twitter google_oauth2 vkontakte].each do |meth|
    define_method(meth) do
      creating = User::CreateFromOAuth.run(params: request.env['omniauth.auth'],
                                           user: current_user)
      if creating.valid?
        sign_in_and_redirect(:user, creating.result)
      else
        redirect_to new_user_registration_path,
                    alert: creating.errors.messages.values.join('<br>')
      end
    end
  end
end
