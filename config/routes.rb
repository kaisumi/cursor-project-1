Rails.application.routes.draw do
  # ヘルスチェック用のエンドポイント
  # アプリケーションが正常に起動しているか確認するために使用されます
  get 'up' => 'rails/health#show', as: :rails_health_check

  # 必要に応じてルートを追加していきます
  # 例: resources :posts
end
