Rails.application.routes.draw do
  devise_for :users, :skip => [:sessions, :registrations]

  as :user do
    get 'login' => 'devise/sessions#new', as: :new_user_session
    post 'login' => 'devise/sessions#create', as: :user_session
    delete 'logout' => 'devise/sessions#destroy', as: :destroy_user_session

    get 'signup' => 'devise/registrations#new', as: :new_user_registration
    post 'signup' => 'devise/registrations#create', as: :user_registration
    put 'signup' => 'devise/registrations#update', as: :update_user_registration
    delete 'signup' => 'devise/registrations#destroy', as: :destroy_user_registration

    get 'settings' => 'devise/registrations#edit', as: :edit_user_registration
  end

  root to: 'static#index'
  resources :users
  resources :sentences


  resources :words do
    collection do
      put :word_action
      put :set_status_on_training
    end
  end
  put '/words' => 'words#index'

  resources :collections
  get '/training' => 'words#training'
end
