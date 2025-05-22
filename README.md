# SNSアプリケーション

## 概要
このリポジトリは、SNSアプリケーションのソースコードを管理するためのものです。

## 技術スタック
- Ruby 3.2.2
- Rails 7.1.x
- PostgreSQL 14
- Redis 7
- Hotwire (Turbo + Stimulus)
- Tailwind CSS

## 開発環境のセットアップ
1. リポジトリをクローン
```bash
git clone https://github.com/kaisumi/cursor-project-1.git
cd cursor-project-1
```

2. 環境変数の設定
```bash
cp .env.example .env
# .envファイルを編集して必要な環境変数を設定
```

3. Dockerコンテナの起動
```bash
docker-compose up -d
```

4. データベースのセットアップ
```bash
docker-compose exec web rails db:create db:migrate db:seed
```

5. アプリケーションの起動
```bash
docker-compose exec web rails server -b 0.0.0.0
```

## テスト
```bash
docker-compose exec web rspec
```

## 開発ワークフロー
このプロジェクトはgit-flowを採用しています。

- `main`: 本番環境用のブランチ
- `develop`: 開発用のブランチ
- `feature/*`: 機能追加用のブランチ
- `release/*`: リリース準備用のブランチ
- `hotfix/*`: 緊急修正用のブランチ

## ドキュメント
詳細なドキュメントは `docs` ディレクトリを参照してください。

- [開発ジャーナル](docs/development/DEVELOPMENT_JOURNAL.md)
- [実装計画](docs/development/IMPLEMENTATION_PLAN.md)
- [マイルストーン](docs/development/milestones/)
- [アーキテクチャ決定記録](docs/adr/)
