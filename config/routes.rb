Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'registrations'}

  as :user do
    put 'users/sign_up' =>  'devise/registrations#update',  as: :update_user_registration
  end

  root to: 'static#index'
  resources :users
  resources :sentences

  resources :articles do
    collection do
      put :delete_articles
    end
  end

  resources :words do
    collection do
      put :word_action
      post :set_word_status_training
    end
  end

  put '/words' => 'words#index'
  get '/training' => 'words#training', as: :training
  get '/result' => 'static#result'
end
