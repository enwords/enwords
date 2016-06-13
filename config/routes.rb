Rails.application.routes.draw do
  devise_for :users
  resources :users

  resources :sentences


  resources :users_words   do
    collection do

      put :set
    end
  end

  resources :words   do
    collection do
      put :set_learning
      put :set_learned
      # put :set
    end
  end
  resources :collections

  root to: 'static#index'
  get '/learning' => 'words#learning'
  get '/learned' => 'words#learned'
  # get '/unset' => 'words#unset'
  get '/unset' => 'users_words#unset'

end
