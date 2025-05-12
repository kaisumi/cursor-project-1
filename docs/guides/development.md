# 開発者ガイド

## 目次
- [開発環境のセットアップ](#開発環境のセットアップ)
- [コーディング規約](#コーディング規約)
- [Git運用ルール](#git運用ルール)
- [品質管理](#品質管理)
- [投稿機能の実装](#投稿機能の実装)

## 開発環境のセットアップ

### 必要条件
- Ruby 3.2.x
- Node.js v20.11.1 以上
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
bundle install
yarn install
```

3. 環境変数の設定
```bash
cp .env.example .env
# .envファイルを編集して必要な値を設定
```

4. Dockerサービスの起動
```bash
docker compose up -d
```

5. データベースのセットアップ
```bash
rails db:create
rails db:migrate
rails db:seed
```

6. 開発サーバーの起動
```bash
./bin/dev
```

### 開発環境の構成

開発環境は以下のサービスで構成されています：

1. **Railsアプリケーション**
   - ホストマシンで直接実行
   - デバッグ機能を活用可能
   - ファイル変更の即時反映

2. **PostgreSQL (Docker)**
   - バージョン: 14
   - ポート: 5432
   - データは永続化（`postgres_data`ボリューム）

3. **Redis (Docker)**
   - バージョン: 7
   - ポート: 6379
   - キャッシュとAction Cable用
   - データは永続化（`redis_data`ボリューム）

4. **Mailcatcher (Docker)**
   - Web UI: http://localhost:1080
   - SMTPポート: 1025
   - 開発環境でのメール送信テスト用

### 開発用コマンド一覧

```bash
# Dockerサービスの操作
docker compose ps          # サービスの状態確認
docker compose logs -f     # ログの確認
docker compose restart     # サービスの再起動
docker compose down        # サービスの停止

# データベース操作
rails db:migrate          # マイグレーションの実行
rails db:rollback         # マイグレーションのロールバック
rails db:seed             # シードデータの投入

# Railsコマンド
rails generate model User  # モデルの生成
rails routes              # ルーティングの確認
rails console            # コンソールの起動

# テストの実行
rspec                    # テストの実行
```

## コーディング規約

### Ruby/Rails規約
- [Ruby Style Guide](https://rubystyle.guide/)に準拠
- [Rails Style Guide](https://rails.rubystyle.guide/)に準拠
- Rubocopの設定に従う

### JavaScript規約
- ESLint設定に従う
- Prettier設定に従う

### 命名規則
- Rubyクラス: PascalCase（例: `UserProfile`）
- Rubyメソッド/変数: snake_case（例: `get_user_data`）
- JavaScript関数/変数: camelCase（例: `getUserData`）
- 定数: SCREAMING_SNAKE_CASE（例: `MAX_RETRY_COUNT`）
- ファイル名: snake_case（例: `user_profile.rb`）

### ファイル構成
```
app/
├── controllers/     # コントローラー
├── models/         # モデル
├── services/       # サービスオブジェクト
├── repositories/   # リポジトリ
├── events/         # イベントオブジェクト
├── views/          # ビューテンプレート
├── javascript/     # JavaScriptファイル
│   ├── controllers/  # Stimulusコントローラー
│   └── channels/    # Action Cableチャンネル
└── assets/        # 静的アセット
```

### コードドキュメント
- クラスとモジュールには必ずドキュメントを記述
- パブリックメソッドには引数と戻り値の説明を記述
- 複雑なロジックには適切なコメントを追加

## Git運用ルール

### ブランチ戦略
- main: 本番環境用
- staging: ステージング環境用
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

### テスト要件
- ユニットテスト: RSpec
  - モデルのカバレッジ: 90%以上
  - サービスのカバレッジ: 90%以上
  - コントローラーのカバレッジ: 85%以上
- 統合テスト: RSpec + Capybara
- E2Eテスト: Cypress

### CI/CD
- GitHub Actionsで自動化
  - Rubocopによる静的解析
  - RSpecによるテスト実行
  - ESLintによるJavaScript解析
  - セキュリティスキャン
- プッシュ時に自動テスト
- PR作成時に自動レビュー

### コードレビュー
- レビュー前に自己レビュー
- レビューコメントへの対応
- レビュー完了後のマージ
- セキュリティレビューの実施

### パフォーマンス要件
- ページロード: 3秒以内
- APIレスポンス: 200ms以内
- データベースクエリ: 100ms以内

## ステータス
- 最終更新日: 2024-04-30
- ステータス: Draft
- レビュー状態: 未レビュー 

## 認証機能の実装

### 1. 必要なgem
```ruby
# Gemfile
gem 'devise'        # 認証基盤
gem 'letter_opener' # 開発環境でのメール送信テスト
```

### 2. 設定ファイル
```ruby
# config/initializers/devise.rb
Devise.setup do |config|
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  config.mailer = 'Devise::Mailer'
  config.parent_mailer = 'ActionMailer::Base'
  config.navigational_formats = ['*/*', :html, :turbo_stream]
  config.sign_out_via = :delete
end
```

### 3. メール設定
```ruby
# config/environments/development.rb
config.action_mailer.delivery_method = :letter_opener
config.action_mailer.default_url_options = { host: 'localhost:3000' }
```

### 4. モデルの実装
```ruby
# app/models/user.rb
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

  def generate_passwordless_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.current
    save!
  end

  private

  def generate_token
    SecureRandom.urlsafe_base64(32)
  end
end
```

### 5. コントローラーの実装
```ruby
# app/controllers/users/passwordless_sessions_controller.rb
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

  def show
    self.resource = resource_class.find_by(reset_password_token: params[:token])
    if resource && resource.token_valid?
      sign_in(resource)
      redirect_to root_path
    else
      redirect_to new_user_passwordless_session_path, alert: '認証に失敗しました'
    end
  end

  private

  def token_valid?
    reset_password_token.present? && 
    reset_password_sent_at > 30.minutes.ago
  end
end
```

### 6. メーラーの実装
```ruby
# app/mailers/user_passwordless_mailer.rb
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

### 7. ビューの実装
```erb
<%# app/views/users/passwordless_sessions/new.html.erb %>
<h2>ログイン</h2>

<%= form_for(resource, as: resource_name, url: user_passwordless_session_path) do |f| %>
  <div class="field">
    <%= f.label :email %><br />
    <%= f.email_field :email, autofocus: true, autocomplete: "email" %>
  </div>

  <div class="actions">
    <%= f.submit "認証メールを送信" %>
  </div>
<% end %>
```

### 8. テストの実装
```ruby
# spec/models/user_spec.rb
RSpec.describe User, type: :model do
  describe '#generate_passwordless_token!' do
    let(:user) { create(:user) }

    it 'generates a token and updates sent_at' do
      expect {
        user.generate_passwordless_token!
      }.to change { user.reset_password_token }.from(nil)
        .and change { user.reset_password_sent_at }.from(nil)
    end
  end
end

# spec/controllers/users/passwordless_sessions_controller_spec.rb
RSpec.describe Users::PasswordlessSessionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'with valid email' do
      it 'sends magic link email' do
        expect {
          post :create, params: { user: { email: user.email } }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end

# spec/mailers/user_passwordless_mailer_spec.rb
RSpec.describe UserPasswordlessMailer, type: :mailer do
  describe 'magic_link' do
    let(:user) { create(:user) }
    let(:mail) { described_class.magic_link(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('認証リンク')
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(/認証リンク/)
    end
  end
end
```

### 9. トラブルシューティング
詳細なトラブルシューティング情報は `docs/development/TROUBLESHOOTING.md` を参照してください。 

## 投稿機能の実装

### 1. モデル構成
```ruby
# app/models/post.rb
class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 10000 }
  validates :user_id, presence: true

  def editable_by?(user)
    return false if user.nil?
    self.user_id == user.id
  end

  def liked_by?(user)
    return false if user.nil?
    likes.exists?(user_id: user.id)
  end
end

# app/models/like.rb
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id }
end
```

### 2. コントローラの実装
```ruby
# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:user, :comments, :likes).order(created_at: :desc)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: '投稿を作成しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: '投稿を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: '投稿を削除しました'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def authorize_user!
    unless @post.editable_by?(current_user)
      redirect_to posts_path, alert: '権限がありません'
    end
  end
end
```

### 3. ビューの構成
- `app/views/posts/index.html.erb`: 投稿一覧表示
- `app/views/posts/show.html.erb`: 投稿詳細表示
- `app/views/posts/new.html.erb`: 新規投稿フォーム
- `app/views/posts/edit.html.erb`: 投稿編集フォーム
- `app/views/posts/_form.html.erb`: 投稿フォームパーシャル

### 4. テストの実装
- モデルスペック: バリデーションとメソッドのテスト
- コントローラスペック: アクションとレスポンスのテスト
- システムスペック: ユーザーインターフェースのテスト

### 5. ルーティング
```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end
end
``` 