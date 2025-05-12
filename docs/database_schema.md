# データベース設計

## テーブル一覧

### users
- id: bigint (PK)
- email: string (unique)
- encrypted_password: string
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

## リレーション
- users has_many posts
- users has_many comments
- posts belongs_to user
- posts has_many comments
- comments belongs_to user
- comments belongs_to post 