Rails.application.routes.draw do
  namespace :api do
    namespace :telegram do
      resources :schedule_bots, only: %i[] do
        collection do
          post :message, defaults: { format: :json }
        end
      end
    end

    resources :words, only: %i[] do
      collection do
        get :generate_phrase, defaults: { format: :json }
        get :random_sentence, defaults: { format: :json }
      end
    end
  end

  get '/words_from_sentence/:sentence_id', to: 'trainings#words_from_sentence'
  get '/change_status/:id/:status', to: 'trainings#change_status'

  as :user do
    put ':locale/users/sign_up' => 'devise/registrations#update', as: :update_user_registration
    get ':id/users/password' => 'devise/passwords#edit', as: :edit_password
  end

  get 'dev' => 'development#index'
  get 'privacy' => 'static#privacy'

  devise_for :users,
             only:        :omniauth_callbacks,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  scope ':locale', locale: /#{I18n.available_locales.join('|')}/ do
    root to: 'static#index'

    devise_for :users,
               skip:        :omniauth_callbacks,
               controllers: { registrations: 'registrations' }

    resources :users, only: %i[] do
      collection do
        put :update_proficiency
      end
    end

    resource :training, only: %i[show] do
      get :result
      put :repeat
    end

    resources :articles do
      post :delete_selected, on: :collection
    end

    resources :audio_articles

    resources :words, only: %i[index] do
      collection do
        put :word_action
      end
    end

    namespace :grammar do
      namespace :eng do
        resources :irregular_verbs, only: %i[index] do
          collection do
            put :create_training
          end
        end
      end
    end

    get '/admin' => 'admin#index'

    namespace :admin do
      resources :sentences
      resources :trainings
      resources :users
    end
  end

  resource :skyeng_setting do
    put :add_token
  end

  get 'first_meaning' => 'skyeng#first_meaning'

  get '*unmatched_route', to: redirect('/', status: 302)
  match '', to: redirect("/#{I18n.default_locale}"), via: [:get]
end
