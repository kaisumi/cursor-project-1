# マイルストーン1: MVP基盤構築（Day 1）
期間: 2024-05-23（1日間）

## 🎯 目標
- 開発環境の整備
- 基本的なユーザー認証の実装
- MVP開発の基盤確立

## 📋 タスク一覧

### 1. 開発環境セットアップ [ENV-001] - 4時間
- [ ] Docker環境の構築
    - PostgreSQL 14
    - Redis 7
    - Mailcatcher
- [ ] Rails 8.0.2アプリケーションの初期化
- [ ] 基本的なGemの導入
    - devise (認証)
    - tailwindcss-rails
    - turbo-rails
    - stimulus-rails

**成果物:**
- 動作する開発環境
- 基本的なRailsアプリケーション

### 2. 認証機能の実装 [AUTH-001] - 4時間
- [ ] メールアドレスによるユーザー登録
- [ ] メールリンク認証（簡素版）
- [ ] ログイン/ログアウト
- [ ] 基本的なユーザープロフィール

**実装範囲:**
- User モデル
- 認証コントローラー
- 基本的なビュー
- メール送信機能（開発環境のみ）

**除外項目:**
- 複雑なトークン管理
- パスワードリセット
- OAuth連携

### 3. 基本データベース設計 [DB-001]
- [ ] Userテーブルの作成
    ```ruby
    # 実装例
    create_table :users do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.timestamps
    end
    add_index :users, :email, unique: true
    ```
- [ ] 基本的なバリデーション
    - メールアドレスの一意性
    - 名前の必須入力

### 4. CI/CD基本設定 [CI-001] - 1時間
- [ ] GitHub Actionsの基本設定
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
- [ ] 基本的なRSpecテストの作成
- [ ] Rubocopの設定

**制限事項（MVP範囲外）:**
- ESLintによるJavaScript解析
- セキュリティスキャン
- 複雑なデプロイパイプライン

## 📊 進捗管理
- [ ] 環境構築完了
- [ ] 認証機能動作確認
- [ ] 基本的なユーザー登録・ログインテスト
- [ ] CI/CD基本設定完了

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