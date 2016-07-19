Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'registrations'}

  as :user do
    put 'users/sign_up' =>  'devise/registrations#update',  as: :update_user_registration
  end

  root to: 'static#index'
  resources :users
  resources :sentences


  resources :words do
    collection do
      put :word_action
      post :create_or_update_word_status
    end
  end
  put '/words' => 'words#index'

  resources :collections
  get '/training' => 'words#training'
end
