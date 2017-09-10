Rails.application.routes.draw do
  get '/words_from_sentence/:id',   to: 'trainings#words_from_sentence'
  get '/change_status/:id/:status', to: 'trainings#change_status'

  as :user do
    put ':locale/users/sign_up' => 'devise/registrations#update', as: :update_user_registration
    get ':id/users/password' => 'devise/passwords#edit', as: :edit_password
  end

  get 'dev' => 'development#index'

  devise_for :users,
             only:        :omniauth_callbacks,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  scope ':locale', locale: /#{I18n.available_locales.join('|')}/ do
    devise_for :users,
               skip:        :omniauth_callbacks,
               controllers: { registrations: 'registrations' }


    root to: 'static#index'

    resources :users
    resource :training do
      get :result
      put :repeat
    end

    resources :articles do
      post :delete_selected, on: :collection
    end

    resources :sentences

    resources :words do
      collection do
        put :word_action
        put :update_proficiency_level
      end
    end
  end

  resource :skyeng_setting do
    put :add_token
  end

  get 'first_meaning' => 'skyeng#first_meaning'

  get '*unmatched_route', to: redirect('/', status: 302)
  match '', to: redirect("/#{I18n.default_locale}"), via: [:get]
end
