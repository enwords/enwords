Rails.application.routes.draw do
  devise_for :users
  resources :users

  resources :rus_sentences
  resources :eng_sentences

  resources :words   do
    collection do
      put :set_learning
    end
  end
  resources :collections
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'static#index'
  get '/learning' => 'words#learning'
  get '/learned' => 'words#learned'

end
