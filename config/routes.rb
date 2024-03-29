Rails.application.routes.draw do
  namespace :api do
    namespace :telegram do
      resources :messages, only: %i[create]
    end

    namespace :public do
      resources :words, only: %i[] do
        collection do
          get :generate_phrase
          get :random_sentence
          get :mnemos
        end
      end

      resources :names, only: %i[] do
        collection do
          get :random
        end
      end
    end

    namespace :mobile do
      resources :articles, only: %i[index create]
      resources :words, only: %i[index]
      resources :trainings, only: %i[create] do
      end
    end

    namespace :web do
      resources :translations, only: %i[index]
      resources :payments, only: %i[] do
        collection do
          post :callback
          get :callback
        end
      end
    end
  end

  get '/translation/:sentence_id', to: 'trainings#translation'
  get '/words_from_sentence/:sentence_id', to: 'trainings#words_from_sentence'
  get '/change_status/:id/:status', to: 'trainings#change_status'

  as :user do
    put ':locale/users/sign_up' => 'devise/registrations#update', as: :update_user_registration
    get ':id/users/password' => 'devise/passwords#edit', as: :edit_password
  end

  get 'hc' => 'application#hc'
  get 'dev' => 'development#index'
  get 'privacy' => 'landings#privacy'

  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  scope ':locale', locale: /#{I18n.available_locales.join('|')}/ do
    root to: 'landings#index'

    resources :blog, only: %i[index show], param: :slug

    devise_for :users, skip: :omniauth_callbacks, controllers: {
      registrations: 'registrations',
      sessions: 'sessions'
    }

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
            put :change_status
          end
        end
        resources :idioms, only: %i[index] do
          collection do
            put :change_status
          end
        end
        resources :phrasal_verbs, only: %i[index] do
          collection do
            put :change_status
          end
        end
        resource :conditional_sentences, only: %i[show]
      end
    end

    get '/admin' => 'admin#index'

    namespace :admin do
      resources :sentences
      resources :trainings
      resources :users do
        collection do
          get :stat
        end
      end
    end
  end

  resources :subscriptions, only: %i[create] do
    collection do
      get :after_checkout
    end
  end

  resource :skyeng_setting do
    put :add_token
  end

  get '*unmatched_route', to: redirect('/', status: 302)
  match '', to: redirect("/#{I18n.default_locale}"), via: [:get]
end
