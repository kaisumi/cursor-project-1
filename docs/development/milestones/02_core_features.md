# マイルストーン2: MVPコア機能実装（Day 2-3）
期間: 2024-05-24 ~ 2024-05-25（2日間）

## 🎯 目標
- SNSの基本機能（投稿・フォロー・いいね）の実装
- データモデルの確立
- 基本的なビジネスロジックの実装

## 📋 タスク一覧

### Day 2: ユーザーモデル拡張と投稿機能

#### 1. ユーザーモデル拡張 [USER-001] - 4時間
- [ ] ユーザーモデルの関連付け実装
    ```ruby
    # app/models/user.rb の実装例
    class User < ApplicationRecord
      has_many :posts, dependent: :destroy
      has_many :active_relationships, class_name: "Relationship",
                                      foreign_key: "follower_id",
                                      dependent: :destroy
      has_many :passive_relationships, class_name: "Relationship",
                                       foreign_key: "followed_id",
                                       dependent: :destroy
      has_many :following, through: :active_relationships, source: :followed
      has_many :followers, through: :passive_relationships, source: :follower
      has_many :likes, dependent: :destroy

      validates :email, presence: true, uniqueness: true
      validates :name, presence: true, length: { maximum: 50 }
    end
    ```

#### 2. 投稿機能の実装 [POST-001] - 8時間
- [ ] 投稿モデルの作成
    ```ruby
    # マイグレーション例
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false
      t.timestamps
    end
    add_index :posts, :user_id
    add_index :posts, :created_at
    ```
- [ ] 投稿のCRUD機能
    - 投稿の作成・編集・削除
    - 投稿の一覧表示（タイムライン）
    - 投稿の詳細表示
- [ ] 投稿のバリデーション
    - 文字数制限（280文字以内）
    - コンテンツの必須入力

**制限事項:**
- 画像投稿は除外
- コメント機能は除外

### Day 3: フォロー機能といいね機能

#### 3. フォロー機能の実装 [FOLLOW-001] - 4時間
- [ ] フォロー関係のモデル作成
    ```ruby
    # マイグレーション例
    create_table :relationships do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], unique: true
    ```
- [ ] フォロー/アンフォロー機能
    - フォロー関係の管理
    - フォロー数・フォロワー数の表示
- [ ] フォロワー/フォロー中の一覧表示

**制限事項:**
- フォロー承認機能は除外
- ブロック機能は除外

#### 4. いいね機能の実装 [LIKE-001] - 4時間
- [ ] いいねモデルの作成
    ```ruby
    # マイグレーション例
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.timestamps
    end
    add_index :likes, :user_id
    add_index :likes, :post_id
    add_index :likes, [:user_id, :post_id], unique: true
    ```
- [ ] いいね/いいね解除機能
- [ ] いいね数の表示
- [ ] いいねした投稿の一覧表示

## 📊 進捗管理
- [ ] ユーザーモデル拡張完了
- [ ] 投稿機能動作確認
- [ ] フォロー機能動作確認
- [ ] いいね機能動作確認
- [ ] 基本的なデータ整合性確認

## 🔍 レビューポイント
- データモデルの整合性
- 基本機能の動作確認
- バリデーションの適切性
- N+1問題の基本対策

## 🔄 依存関係
- マイルストーン1（基盤構築）の完了が必要
- マイルストーン3（UI実装）の前提条件となる

## 🛠 技術スタック
- バックエンド: Ruby on Rails 7
- データベース: PostgreSQL 14
- テスト: RSpec（基本的なモデルテスト）

## 📝 注意事項
- 機能実装に集中し、UI は最小限に留める
- パフォーマンス最適化は基本的なインデックス設定のみ
- 複雑な機能は後のフェーズに延期