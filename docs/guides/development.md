# 開発者ガイド

## 目次
- [開発環境のセットアップ](#開発環境のセットアップ)
- [コーディング規約](#コーディング規約)
- [Git運用ルール](#git運用ルール)
- [品質管理](#品質管理)

## 開発環境のセットアップ

### 必要条件
- Ruby 3.4.3
- Node.js v20.11.1 以上
- Docker Desktop 最新版
- Git 2.39.0 以上

### 初期セットアップ
1. リポジトリのクローン
```bash
git clone https://github.com/your-org/your-repo.git
cd your-repo
```

2. 依存関係のインストール
```bash
bundle install
yarn install
```

3. 環境変数の設定
```bash
cp .env.example .env
# .envファイルを編集して必要な値を設定
```

4. Dockerサービスの起動
```bash
docker compose up -d
```

5. データベースのセットアップ
```bash
rails db:create
rails db:migrate
rails db:seed
```

6. 開発サーバーの起動
```bash
./bin/dev
```

### 開発環境の構成

開発環境は以下のサービスで構成されています：

1. **Railsアプリケーション**
   - ホストマシンで直接実行
   - デバッグ機能を活用可能
   - ファイル変更の即時反映

2. **PostgreSQL (Docker)**
   - バージョン: 14
   - ポート: 5432
   - データは永続化（`postgres_data`ボリューム）

3. **Redis (Docker)**
   - バージョン: 7
   - ポート: 6379
   - キャッシュとAction Cable用
   - データは永続化（`redis_data`ボリューム）

4. **Mailcatcher (Docker)**
   - Web UI: http://localhost:1080
   - SMTPポート: 1025
   - 開発環境でのメール送信テスト用

### 開発用コマンド一覧

```bash
# Dockerサービスの操作
docker compose ps          # サービスの状態確認
docker compose logs -f     # ログの確認
docker compose restart     # サービスの再起動
docker compose down        # サービスの停止

# データベース操作
rails db:migrate          # マイグレーションの実行
rails db:rollback         # マイグレーションのロールバック
rails db:seed             # シードデータの投入

# Railsコマンド
rails generate model User  # モデルの生成
rails routes              # ルーティングの確認
rails console            # コンソールの起動

# テストの実行
rspec                    # テストの実行
```

## コーディング規約

### Ruby/Rails規約
- [Ruby Style Guide](https://rubystyle.guide/)に準拠
- [Rails Style Guide](https://rails.rubystyle.guide/)に準拠
- Rubocopの設定に従う

### JavaScript規約
- ESLint設定に従う
- Prettier設定に従う

### 命名規則
- Rubyクラス: PascalCase（例: `UserProfile`）
- Rubyメソッド/変数: snake_case（例: `get_user_data`）
- JavaScript関数/変数: camelCase（例: `getUserData`）
- 定数: SCREAMING_SNAKE_CASE（例: `MAX_RETRY_COUNT`）
- ファイル名: snake_case（例: `user_profile.rb`）

### ファイル構成
```
app/
├── controllers/     # コントローラー
├── models/         # モデル
├── services/       # サービスオブジェクト
├── repositories/   # リポジトリ
├── events/         # イベントオブジェクト
├── views/          # ビューテンプレート
├── javascript/     # JavaScriptファイル
│   ├── controllers/  # Stimulusコントローラー
│   └── channels/    # Action Cableチャンネル
└── assets/        # 静的アセット
```

### コードドキュメント
- クラスとモジュールには必ずドキュメントを記述
- パブリックメソッドには引数と戻り値の説明を記述
- 複雑なロジックには適切なコメントを追加

## Git運用ルール

### ブランチ戦略
- main: 本番環境用
- staging: ステージング環境用
- develop: 開発環境用
- feature/*: 機能開発用
- fix/*: バグ修正用
- release/*: リリース準備用

### コミットメッセージ
```
<type>(<scope>): <subject>

<body>

<footer>
```

type:
- feat: 新機能
- fix: バグ修正
- docs: ドキュメント
- style: フォーマット
- refactor: リファクタリング
- test: テスト
- chore: その他

### PRプロセス
1. 適切なブランチを作成
2. 変更を実装
3. テストを実行
4. PRを作成
5. レビューを受ける
6. 承認後にマージ

## 品質管理

### テスト要件
- ユニットテスト: RSpec
  - モデルのカバレッジ: 90%以上
  - サービスのカバレッジ: 90%以上
  - コントローラーのカバレッジ: 85%以上
- 統合テスト: RSpec + Capybara
- E2Eテスト: Cypress

### CI/CD
- GitHub Actionsで自動化
  - Rubocopによる静的解析
  - RSpecによるテスト実行
  - ESLintによるJavaScript解析
  - セキュリティスキャン
- プッシュ時に自動テスト
- PR作成時に自動レビュー

### コードレビュー
- レビュー前に自己レビュー
- レビューコメントへの対応
- レビュー完了後のマージ
- セキュリティレビューの実施

### パフォーマンス要件
- ページロード: 3秒以内
- APIレスポンス: 200ms以内
- データベースクエリ: 100ms以内

## ステータス
- 最終更新日: 2024-04-30
- ステータス: Draft
- レビュー状態: 未レビュー 