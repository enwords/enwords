Rails.application.routes.draw do
  devise_for :users
  resources :users

  resources :sentences

  resources :words   do
    collection do
      put :set_learning
      put :set_learned
    end
  end
  resources :collections

  root to: 'static#index'
  get '/learning' => 'words#learning'
  get '/learned' => 'words#learned'

end
