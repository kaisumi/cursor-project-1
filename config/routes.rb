Rails.application.routes.draw do
  # Devise のルーティング
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # ルートパス
  root "posts#index"
  
  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  # ユーザー関連
  resources :users, only: [:show] do
    member do
      get :following, :followers
    end
  end

  # フォロー機能
  resources :relationships, only: [:create, :destroy]

  # 投稿関連
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end

  # パスワードレス認証
  namespace :users do
    resource :passwordless_session, only: [:new, :create, :show]
  end

  # PWA関連（必要に応じてコメントアウトを解除）
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
