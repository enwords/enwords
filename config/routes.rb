Rails.application.routes.draw do
  devise_for :users
  resources :users

  resources :rus_sentences
  resources :eng_sentences

  resources :eng_words   do
    collection do
      put :is_learned
    end
  end
  resources :word_collections
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'static#index'
  get '/learning' => 'eng_words#learning'
  get '/learned' => 'eng_words#learned'

end
