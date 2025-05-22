# データベース設計

## テーブル一覧

### users
- id: bigint (PK)
- email: string (unique)
- encrypted_password: string
- name: string (null: false, default: "Anonymous")
- created_at: datetime
- updated_at: datetime

### posts
- id: bigint (PK)
- title: string
- content: text
- user_id: bigint (FK)
- created_at: datetime
- updated_at: datetime

### comments
- id: bigint (PK)
- content: text
- user_id: bigint (FK)
- post_id: bigint (FK)
- created_at: datetime
- updated_at: datetime

### likes
- id: bigint (PK)
- user_id: bigint (FK)
- post_id: bigint (FK)
- created_at: datetime
- updated_at: datetime

### relationships
- id: bigint (PK)
- follower_id: bigint (FK to users.id)
- followed_id: bigint (FK to users.id)
- created_at: datetime
- updated_at: datetime
- インデックス:
  - [follower_id, followed_id] (ユニーク)
  - [followed_id] (検索パフォーマンス向上のため)

## リレーション
- users has_many posts
- users has_many comments
- users has_many likes
- users has_many active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
- users has_many following, through: :active_relationships, source: :followed
- users has_many passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
- users has_many followers, through: :passive_relationships, source: :follower
- posts belongs_to user
- posts has_many comments
- posts has_many likes
- comments belongs_to user
- comments belongs_to post
- likes belongs_to user
- likes belongs_to post
- relationships belongs_to :follower, class_name: "User"
- relationships belongs_to :followed, class_name: "User" 