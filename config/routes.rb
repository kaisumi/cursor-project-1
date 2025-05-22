Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Authentication routes
  post '/auth/login', to: 'auth#login'
  get '/auth/verify', to: 'auth#verify'
  delete '/auth/logout', to: 'auth#logout'
  
  # Posts routes
  resources :posts
  
  # Likes routes
  resources :likes, only: [:destroy]
  resources :posts do
    resources :likes, only: [:create]
  end
  
  # Relationships routes
  resources :relationships, only: [:create, :destroy]
  
  # Users routes
  resources :users, only: [:show] do
    member do
      get :following, :followers
    end
  end
  
  # Notifications routes
  resources :notifications, only: [:index] do
    member do
      post :mark_as_read
    end
    collection do
      post :mark_all_as_read
    end
  end
  
  # Search routes
  resources :search, only: [:index]
  
  # Mount Action Cable
  mount ActionCable.server => '/cable'

  # Root path
  root "home#index"
end
