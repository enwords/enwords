Rails.application.routes.draw do
  resources :rus_sentences
  resources :eng_sentences
  resources :eng_words
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'static#index'

end
