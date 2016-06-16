Rails.application.routes.draw do
  devise_for :users
  resources :users

  resources :sentences

  resources :words   do
    collection do
      put :update_word_status
      put :set_word_status
    end
  end
  resources :collections

  root to: 'static#index'
  get '/learning' => 'words#learning'
  get '/learned' => 'words#learned'
  get '/unset' => 'words#unset'
end
