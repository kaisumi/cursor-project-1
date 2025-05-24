# マイルストーン1: MVP基盤構築（Day 1）
期間: 2024-05-23（1日間）

## 🎯 目標
- 開発環境の整備
- 基本的なユーザー認証の実装
- MVP開発の基盤確立

## 📋 タスク一覧

### 1. 開発環境セットアップ [ENV-001] - 4時間
- [x] Docker環境の構築
    - PostgreSQL 14
    - Redis 7
    - Mailcatcher
- [x] Rails 8.0.2アプリケーションの初期化
- [x] 基本的なGemの導入
    - devise (認証)
    - tailwindcss-rails
    - turbo-rails
    - stimulus-rails
    - rspec-rails (テスト)
    - factory_bot_rails (テストデータ)
    - faker (テストデータ)

**成果物:**
- 動作する開発環境
- 基本的なRailsアプリケーション
- Deviseによる認証機能

**完了したPR:**
- PR #24: ENV-001: Docker環境の構築
- PR #XX: ENV-001: Rails 8.0.2アプリケーションの初期化

### 2. 認証機能の実装 [AUTH-001] - 4時間
- [x] メールアドレスによるユーザー登録
- [x] パスワード認証
- [x] ログイン/ログアウト
- [x] 基本的なユーザープロフィール（名前、メールアドレス）

**実装範囲:**
- User モデル（Devise）
- 認証コントローラー（Devise）
- 基本的なビュー（カスタマイズ済み）
- メール送信機能（開発環境のみ、Mailcatcher）

**除外項目:**
- メールリンク認証（次のフェーズで実装予定）
- 複雑なトークン管理
- OAuth連携

### 3. 基本データベース設計 [DB-001]
- [x] Userテーブルの作成（Deviseによる自動生成）
    ```ruby
    # 実際の実装（db/migrate/YYYYMMDDHHMMSS_devise_create_users.rb）
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :name,               null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    ```
- [x] 基本的なバリデーション
    - メールアドレスの一意性（Deviseによる自動実装）
    - 名前の必須入力（追加実装）
    ```ruby
    # app/models/user.rb
    validates :name, presence: true
    ```

### 4. CI/CD基本設定 [CI-001] - 1時間
- [x] GitHub Actionsの基本設定
    ```yaml
    # .github/workflows/ci.yml
    name: CI
    on: [push, pull_request]
    jobs:
      test:
        runs-on: ubuntu-latest
        services:
          postgres:
            image: postgres:14
            env:
              POSTGRES_PASSWORD: postgres
            options: >-
              --health-cmd pg_isready
              --health-interval 10s
              --health-timeout 5s
              --health-retries 5
        steps:
          - uses: actions/checkout@v3
          - uses: ruby/setup-ruby@v1
            with:
              bundler-cache: true
          - name: Setup Database
            run: |
              bundle exec rails db:create
              bundle exec rails db:migrate
          - name: Run Tests
            run: bundle exec rspec
          - name: Run Rubocop
            run: bundle exec rubocop
    ```
- [x] 基本的なRSpecテストの作成
- [x] Rubocopの設定

**制限事項（MVP範囲外）:**
- ESLintによるJavaScript解析
- セキュリティスキャン
- 複雑なデプロイパイプライン

## 📊 進捗管理
- [x] 環境構築完了
- [x] 認証機能動作確認
- [x] 基本的なユーザー登録・ログインテスト
- [x] CI/CD基本設定完了

## 🔍 レビューポイント
- 開発環境の動作確認
- 認証機能の基本動作
- セキュリティの基本対策
- 次日への準備完了

## 🔄 依存関係
- なし（プロジェクト開始）

## 🛠 技術スタック
- バックエンド: Ruby on Rails 8.0.2
- データベース: PostgreSQL 14
- キャッシュ: Redis 7
- 認証: Devise
- フロントエンド: Hotwire (Turbo + Stimulus)
- CSS: Tailwind CSS