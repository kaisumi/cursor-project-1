# マイルストーン3: 将来拡張機能（Phase 2）
期間: MVP完了後の将来実装

## 🎯 目標
- リアルタイム通知機能の実装
- 検索機能の追加
- セキュリティの強化

## ⚠️ 注意
このマイルストーンは1週間MVP開発には含まれません。MVP完了後の将来拡張として実装予定です。

## 📋 タスク一覧

### 1. リアルタイム通知機能 [NOTIFY-001]
- [ ] Action Cableの設定
    ```ruby
    # 実装例
    class NotificationsChannel < ApplicationCable::Channel
      def subscribed
        stream_from "notifications_#{current_user.id}"
      end
    end
    ```
- [ ] 通知モデルの作成
    ```ruby
    # 実装例
    create_table :notifications do |t|
      t.references :user, null: false
      t.references :notifiable, polymorphic: true
      t.string :action, null: false
      t.boolean :read, default: false
      t.timestamps
    end
    ```
- [ ] 通知の種類
    - フォロー通知
    - いいね通知
    - コメント通知
- [ ] 通知の配信
    - WebSocketによるリアルタイム配信
    - メール通知（オプション）

### 2. 検索機能の強化 [SEARCH-001]
- [ ] 全文検索の実装
    - PostgreSQLの全文検索機能の設定
    - 検索インデックスの作成
- [ ] 検索結果の最適化
    - 関連度によるソート
    - フィルタリング機能
- [ ] 検索履歴の管理
    - 最近の検索の保存
    - 人気の検索ワードの表示

### 3. セキュリティ強化 [SEC-001]
> 注意: このセクションではセキュリティ機能の実装に焦点を当てます。セキュリティイベントの監視と分析はマイルストーン5で実施します。
- [ ] レート制限の実装
    - APIエンドポイントの制限
    - ログイン試行の制限
- [ ] セキュリティヘッダーの設定
    - CSPの設定
    - XSS対策
    - CSRF対策
- [ ] ログ監視の強化
    - セキュリティログの収集
    - 異常検知の設定

### 4. パフォーマンスモニタリング [MONITOR-001]
> 注意: このセクションでは基本的なパフォーマンスモニタリングの設定に焦点を当てます。詳細な分析とアラート設定はマイルストーン5で実施します。
- [ ] アプリケーション監視の設定
    - NewRelic/Sentryの導入
    - カスタムメトリクスの設定
- [ ] エラートラッキング
    - エラーログの収集
    - アラートの設定
- [ ] パフォーマンス分析
    - スロークエリの検出
    - メモリ使用量の監視

### 5. バックアップ戦略 [BACKUP-001]
- [ ] データベースバックアップ
    - 自動バックアップの設定
    - リストア手順の作成
- [ ] メディアファイルのバックアップ
    - S3/Cloud Storageの設定
    - バックアップの検証

## 📊 進捗管理
- 機能の実装状況
- パフォーマンス指標
- セキュリティテスト結果

## 🔍 レビューポイント
- リアルタイム機能の信頼性
- セキュリティ要件の充足
- パフォーマンスの維持
- バックアップの信頼性

## 🔄 依存関係
- マイルストーン2（コア機能）の完了が必要
- マイルストーン4（UI/UX）の基盤となる
- マイルストーン5（分析・モニタリング）の前提条件となる 