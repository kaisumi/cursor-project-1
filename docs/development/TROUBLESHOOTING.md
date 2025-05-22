# トラブルシューティングガイド

## 開発環境の問題

### Docker関連
#### 1. PostgreSQLに接続できない
- 症状: データベース接続エラー
- 解決手順:
  1. コンテナの状態確認
     ```bash
     docker compose ps
     ```
  2. ログの確認
     ```bash
     docker compose logs db
     ```
  3. コンテナの再起動
     ```bash
     docker compose restart db
     ```
  4. データボリュームの確認
     ```bash
     docker volume ls
     ```

#### 2. Redisに接続できない
- 症状: Redis接続エラー
- 解決手順:
  1. コンテナの状態確認
     ```bash
     docker compose ps
     ```
  2. ログの確認
     ```bash
     docker compose logs redis
     ```
  3. コンテナの再起動
     ```bash
     docker compose restart redis
     ```

### アプリケーション関連
#### 1. テストが失敗する
- 症状: テスト実行時のエラー
- 解決手順:
  1. テストデータベースの状態確認
     ```bash
     rails db:test:prepare
     ```
  2. テストの詳細出力
     ```bash
     rspec --format documentation
     ```
  3. 特定のテストの実行
     ```bash
     rspec spec/path/to/test_spec.rb
     ```

#### 2. アセットのコンパイルエラー
- 症状: アセットのコンパイル失敗
- 解決手順:
  1. キャッシュのクリア
     ```bash
     rails assets:clobber
     ```
  2. アセットの再コンパイル
     ```bash
     rails assets:precompile
     ```

## 本番環境の問題

### デプロイ関連
#### 1. デプロイが失敗する
- 症状: デプロイプロセスのエラー
- 解決手順:
  1. デプロイログの確認
  2. 環境変数の確認
  3. データベースマイグレーションの確認

#### 2. アプリケーションが起動しない
- 症状: アプリケーションの起動エラー
- 解決手順:
  1. アプリケーションログの確認
  2. サーバーリソースの確認
  3. 依存関係の確認

## 共通のトラブルシューティング手順

### 1. ログの確認方法
```bash
# アプリケーションログ
tail -f log/development.log

# テストログ
tail -f log/test.log

# Dockerログ
docker compose logs -f
```

### 2. 環境変数の確認
```bash
# 環境変数の一覧表示
env | grep RAILS
```

### 3. データベースの状態確認
```bash
# データベースの状態
rails db:version

# マイグレーションの状態
rails db:migrate:status
```

## トラブルシューティングの記録
新しい問題が発生した場合は、以下の形式で記録してください：

```markdown
## [問題のタイトル]
- 症状: [具体的な症状]
- 発生環境: [開発/本番]
- 解決手順:
  1. [手順1]
  2. [手順2]
  3. [手順3]
- 解決策: [最終的な解決策]
- 参考リンク: [関連するドキュメントやIssue]
```

## Sentryの設定問題
- 症状: Sentryへのエラー送信が機能しない
- 発生環境: 開発/本番
- 解決手順:
  1. 環境変数の確認
     ```bash
     echo $SENTRY_DSN
     ```
  2. Sentryの初期化コードの確認
     ```ruby
     # config/initializers/monitoring.rb
     Sentry.init do |config|
       config.dsn = ENV['SENTRY_DSN']
       # 他の設定...
     end
     ```
  3. テストエラーの送信
     ```ruby
     Sentry.capture_message("テストメッセージ")
     ```
- 解決策: 正しいSentry DSNを環境変数に設定し、アプリケーションを再起動する
- 参考リンク: https://docs.sentry.io/platforms/ruby/

## AWS S3バックアップの問題
- 症状: S3へのバックアップアップロードが失敗する
- 発生環境: 開発/本番
- 解決手順:
  1. AWS認証情報の確認
     ```bash
     echo $AWS_ACCESS_KEY_ID
     echo $AWS_SECRET_ACCESS_KEY
     echo $AWS_REGION
     echo $AWS_BUCKET_NAME
     ```
  2. S3バケットの存在確認
     ```ruby
     require 'aws-sdk-s3'
     s3 = Aws::S3::Resource.new
     bucket = s3.bucket(ENV['AWS_BUCKET_NAME'])
     puts bucket.exists?
     ```
  3. バケットへの書き込み権限テスト
     ```ruby
     obj = bucket.object('test.txt')
     obj.put(body: 'テスト')
     ```
- 解決策: 正しいAWS認証情報を設定し、バケットに適切なアクセス権限があることを確認する
- 参考リンク: https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Resource.html 