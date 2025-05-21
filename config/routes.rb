Rails.application.routes.draw do
  get "users/show"
  get "users/following"
  get "users/followers"
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # フォロー機能のルーティング
  resources :relationships, only: [:create, :destroy] do
    collection do
      get 'followers'
      get 'following'
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "posts#index"

  namespace :users do
    resource :passwordless_session, only: [ :new, :create, :show ]
  end

  resources :posts do
    resources :comments, only: [ :create, :destroy ]
    resources :likes, only: [ :create, :destroy ]
  end
  
  # ユーザープロフィール表示用
  resources :users, only: [:show] do
    member do
      get :following, :followers
    end
  end
end
