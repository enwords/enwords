Rails.application.routes.draw do
  devise_for :users, :skip => [:sessions, :registrations]

  as :user do
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    delete 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session

    get 'sign_up' => 'devise/registrations#new', :as => :new_user_registration
    post 'sign_up' => 'devise/registrations#create', :as => :user_registration
    get 'settings' => 'devise/registrations#edit', :as => :edit_user_registration
    delete 'sign_up' => 'devise/registrations#destroy', :as => :destroy_user_registration
  end

  resources :users

  resources :sentences

  resources :words   do
    collection do
      put :word_action
      # put :practice
    end
  end

  resources :collections

  root to: 'static#index'
  get '/learning' => 'words#learning'
  get '/learned' => 'words#learned'
  get '/unset' => 'words#unset'
  get '/practice' => 'words#practice'
end
