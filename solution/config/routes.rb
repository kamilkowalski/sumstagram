Rails.application.routes.draw do
  resources :users, only: [:create]
  resource :access_tokens, only: [:create, :update]
  resources :photos, only: [:index, :create] do
    resources :comments, only: [:index, :create]
  end
end
