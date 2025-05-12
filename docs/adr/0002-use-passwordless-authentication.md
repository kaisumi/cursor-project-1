# ADR 0002: パスワードレス認証の採用

## ステータス
承認

## コンテキスト
SNSアプリケーションの認証方式を選択する必要があります。以下の要件を満たす必要があります：
- セキュリティの確保
- ユーザビリティの向上
- 実装の容易さ
- メンテナンス性
- 将来的な拡張性

## 決定
パスワードレス認証（メールリンク認証）を採用します。

具体的な実装方針：
1. メールリンクによる認証
   - ワンタイムトークンの使用
   - 有効期限の設定
   - セキュアなトークン生成

2. セッション管理
   - JWTトークンの使用
   - リフレッシュトークンの実装
   - セキュアなクッキー設定

3. セキュリティ対策
   - レート制限の実装
   - IPアドレスベースの制限
   - 不正アクセス検知

## 実装詳細

### 1. 技術スタック
- Devise: 認証基盤
- Letter Opener: 開発環境でのメール送信テスト
- Redis: セッションストア
- Action Mailer: メール送信

### 2. コンポーネント実装
#### 2.1 モデル層
```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :authentication_keys => [:email]

  def password_required?
    false
  end

  def email_required?
    true
  end
end
```

#### 2.2 コントローラー層
```ruby
class Users::PasswordlessSessionsController < Devise::SessionsController
  def create
    self.resource = resource_class.find_by(email: params[:user][:email])
    if resource
      resource.generate_passwordless_token!
      UserPasswordlessMailer.magic_link(resource).deliver_now
      redirect_to root_path, notice: '認証メールを送信しました'
    else
      redirect_to new_user_passwordless_session_path, alert: 'メールアドレスが見つかりません'
    end
  end
end
```

#### 2.3 メーラー層
```ruby
class UserPasswordlessMailer < Devise::Mailer
  def magic_link(record)
    @user = record
    @token = record.reset_password_token
    @email = record.email
    mail(
      to: @email,
      subject: '認証リンク'
    )
  end
end
```

### 3. セキュリティ実装
- トークンの有効期限: 30分
- レート制限: 1時間あたり5回まで
- セッションタイムアウト: 24時間
- セキュアなクッキー設定

### 4. テスト戦略
- モデルテスト: トークン生成と検証
- コントローラーテスト: 認証フロー
- メーラーテスト: メール送信
- 統合テスト: エンドツーエンドの認証フロー

### 5. 監視とログ
- 認証イベントのログ記録
- エラー監視と通知
- パフォーマンスメトリクスの収集

### 6. 今後の改善点
- ソーシャルログインの追加
- 2要素認証の実装
- モバイルアプリ対応
- 多言語対応

## 結果
メリット：
- パスワード管理の負担がない
- セキュリティリスクの低減
- 実装が比較的容易
- ユーザー体験の向上

デメリット：
- メールサーバーの依存
- メールの遅延の可能性
- メールアドレスの変更時の対応が必要

## 代替案
1. 従来のパスワード認証
   - メリット：
     - 実装が簡単
     - ユーザーに馴染みがある
   - デメリット：
     - セキュリティリスクが高い
     - パスワード管理の負担
     - パスワードリセット機能の必要性

2. OAuth認証
   - メリット：
     - 実装が容易
     - 信頼性が高い
     - ユーザー情報の取得が容易
   - デメリット：
     - 外部サービスへの依存
     - プライバシーの懸念
     - カスタマイズの制限

3. 生体認証
   - メリット：
     - 高いセキュリティ
     - 優れたユーザー体験
   - デメリット：
     - 実装が複雑
     - デバイス依存
     - コストが高い 