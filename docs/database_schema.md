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

## リレーション
- users has_many posts
- users has_many comments
- users has_many likes
- posts belongs_to user
- posts has_many comments
- posts has_many likes
- comments belongs_to user
- comments belongs_to post
- likes belongs_to user
- likes belongs_to post 