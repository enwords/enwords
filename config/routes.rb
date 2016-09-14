Rails.application.routes.draw do

  # default_url_options :host => "localhost:3000"
  get 'words_in_sentence/:id' => 'words#words_in_sentence'

  as :user do
    put ':locale/users/sign_up' => 'devise/registrations#update', as: :update_user_registration
    get ':locale/users/password' => 'devise/passwords#edit', as: :edit_password
  end

  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users, controllers: {registrations: 'registrations'}

    root to: 'static#index'
    put '/words' => 'words#index'
    get '/training' => 'words#training', as: :training
    get '/result' => 'static#result'

    resources :users
    resources :sentences
    resources :articles do
      collection do
        put :delete_articles
      end
    end

    resources :words do
      collection do
        put :word_action
        post :set_word_status_training
      end
    end
  end

  match '*path', to: redirect("/#{I18n.default_locale}/%{path}%"), via: [:get]
  match '', to: redirect("/#{I18n.default_locale}"), via: [:get]
end
