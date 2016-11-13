Rails.application.routes.draw do
  resources :users, only: [:create]
  resource :access_tokens, only: [:create, :update]
end
