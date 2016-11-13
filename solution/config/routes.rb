Rails.application.routes.draw do
  resources :users, only: [:create]
  resources :access_tokens, only: [:create, :update]
end
