# SNS MVP アプリケーション

## 開発環境のセットアップ

### 前提条件
- Docker と Docker Compose がインストールされていること
- Git がインストールされていること

### セットアップ手順

1. リポジトリをクローン
```bash
git clone <repository-url>
cd cursor-project-1
```

2. セットアップスクリプトを実行
```bash
chmod +x setup.sh
./setup.sh
```

3. アプリケーションの起動
```bash
docker-compose up
```

4. ブラウザでアクセス
```
http://localhost:3000
```

## 開発環境の構成

- Ruby: 3.4.3
- Rails: 8.0.2
- PostgreSQL: 14
- Redis: 7
- Mailcatcher: 開発用メールサーバー

## 主要な機能

- ユーザー認証（Devise）
- 投稿機能
- フォロー機能
- いいね機能
- レスポンシブUI

## テスト実行

```bash
docker-compose run --rm web bundle exec rspec
```

## Lintの実行

```bash
docker-compose run --rm web bundle exec rubocop
```

## CI/CD

GitHub Actionsを使用して、以下を自動化しています：
- テストの実行
- コードスタイルチェック
- 将来的にデプロイも自動化予定