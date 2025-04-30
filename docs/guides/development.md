# 開発者ガイド

## 目次
- [開発環境のセットアップ](#開発環境のセットアップ)
- [コーディング規約](#コーディング規約)
- [Git運用ルール](#git運用ルール)
- [品質管理](#品質管理)

## 開発環境のセットアップ

### 必要条件
- Node.js v20.11.1 以上
- pnpm v8.15.4 以上
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
pnpm install
```

3. 環境変数の設定
```bash
cp .env.example .env
# .envファイルを編集して必要な値を設定
```

4. 開発サーバーの起動
```bash
pnpm dev
```

## コーディング規約

### 命名規則
- ファイル名: kebab-case（例: `user-profile.tsx`）
- コンポーネント: PascalCase（例: `UserProfile`）
- 関数/変数: camelCase（例: `getUserData`）
- 定数: UPPER_SNAKE_CASE（例: `MAX_RETRY_COUNT`）
- 型/インターフェース: PascalCase（例: `UserProfileProps`）

### ファイル構成
```
src/
├── components/     # 再利用可能なコンポーネント
├── features/       # 機能単位のモジュール
├── hooks/         # カスタムフック
├── lib/           # ユーティリティ関数
├── pages/         # ページコンポーネント
└── types/         # 型定義
```

### コードフォーマット
- Prettierを使用
- 設定ファイル: `.prettierrc`
- 保存時に自動フォーマット

### ESLintルール
- 設定ファイル: `.eslintrc.js`
- 主要ルール:
  - `react-hooks/rules-of-hooks`
  - `@typescript-eslint/explicit-function-return-type`
  - `import/order`

## Git運用ルール

### ブランチ戦略
- main: 本番環境用
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

### テスト
- ユニットテスト: `pnpm test`
- E2Eテスト: `pnpm test:e2e`
- カバレッジレポート: `pnpm test:coverage`

### CI/CD
- GitHub Actionsで自動化
- プッシュ時に自動テスト
- PR作成時に自動レビュー

### コードレビュー
- レビュー前に自己レビュー
- レビューコメントへの対応
- レビュー完了後のマージ

## ステータス
- 最終更新日: 2024-04-30
- ステータス: Draft
- レビュー状態: 未レビュー 