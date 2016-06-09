Rails.application.routes.draw do
  devise_for :users
  resources :users

  resources :rus_sentences
  resources :eng_sentences

  resources :eng_words
  resources :word_collections
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'static#index'
  get '/lwords' => 'eng_words#lwords'

end
