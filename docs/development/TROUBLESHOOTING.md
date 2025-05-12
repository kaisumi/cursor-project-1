# トラブルシューティングガイド

## 開発環境の問題

### Docker関連
#### 1. PostgreSQLに接続できない
- 症状: データベース接続エラー
- 解決手順:
  1. コンテナの状態確認
     ```bash
     docker compose ps
     ```
  2. ログの確認
     ```bash
     docker compose logs db
     ```
  3. コンテナの再起動
     ```bash
     docker compose restart db
     ```
  4. データボリュームの確認
     ```bash
     docker volume ls
     ```

#### 2. Redisに接続できない
- 症状: Redis接続エラー
- 解決手順:
  1. コンテナの状態確認
     ```bash
     docker compose ps
     ```
  2. ログの確認
     ```bash
     docker compose logs redis
     ```
  3. コンテナの再起動
     ```bash
     docker compose restart redis
     ```

### アプリケーション関連
#### 1. テストが失敗する
- 症状: テスト実行時のエラー
- 解決手順:
  1. テストデータベースの状態確認
     ```bash
     rails db:test:prepare
     ```
  2. テストの詳細出力
     ```bash
     rspec --format documentation
     ```
  3. 特定のテストの実行
     ```bash
     rspec spec/path/to/test_spec.rb
     ```

#### 2. アセットのコンパイルエラー
- 症状: アセットのコンパイル失敗
- 解決手順:
  1. キャッシュのクリア
     ```bash
     rails assets:clobber
     ```
  2. アセットの再コンパイル
     ```bash
     rails assets:precompile
     ```

## 本番環境の問題

### デプロイ関連
#### 1. デプロイが失敗する
- 症状: デプロイプロセスのエラー
- 解決手順:
  1. デプロイログの確認
  2. 環境変数の確認
  3. データベースマイグレーションの確認

#### 2. アプリケーションが起動しない
- 症状: アプリケーションの起動エラー
- 解決手順:
  1. アプリケーションログの確認
  2. サーバーリソースの確認
  3. 依存関係の確認

## 共通のトラブルシューティング手順

### 1. ログの確認方法
```bash
# アプリケーションログ
tail -f log/development.log

# テストログ
tail -f log/test.log

# Dockerログ
docker compose logs -f
```

### 2. 環境変数の確認
```bash
# 環境変数の一覧表示
env | grep RAILS
```

### 3. データベースの状態確認
```bash
# データベースの状態
rails db:version

# マイグレーションの状態
rails db:migrate:status
```

## トラブルシューティングの記録
新しい問題が発生した場合は、以下の形式で記録してください：

```markdown
## [問題のタイトル]
- 症状: [具体的な症状]
- 発生環境: [開発/本番]
- 解決手順:
  1. [手順1]
  2. [手順2]
  3. [手順3]
- 解決策: [最終的な解決策]
- 参考リンク: [関連するドキュメントやIssue]
```

## 認証関連の問題

### メールが送信されない
**症状**:
- 認証メールが届かない
- メール送信エラーが発生する

**確認手順**:
1. 開発環境の設定を確認
   ```ruby
   # config/environments/development.rb
   config.action_mailer.delivery_method = :letter_opener
   config.action_mailer.default_url_options = { host: 'localhost:3000' }
   ```
2. メール送信のログを確認
   ```bash
   tail -f log/development.log
   ```
3. Letter Openerの動作を確認
   - http://localhost:3000/letter_opener にアクセス
   - メールのプレビューが表示されるか確認

**解決策**:
- メール設定の見直し
- メールサーバーの状態確認
- メールテンプレートの確認

### トークンが無効
**症状**:
- 認証リンクが機能しない
- トークン無効のエラーが表示される

**確認手順**:
1. トークンの有効期限を確認
   ```ruby
   # app/models/user.rb
   def generate_passwordless_token!
     self.reset_password_token = generate_token
     self.reset_password_sent_at = Time.current
     save!
   end
   ```
2. トークンの形式を確認
   ```ruby
   # app/controllers/users/passwordless_sessions_controller.rb
   def token_valid?
     reset_password_token.present? && 
     reset_password_sent_at > 30.minutes.ago
   end
   ```

**解決策**:
- トークンの再生成
- 有効期限の延長
- トークン生成ロジックの見直し

### セッションが作成されない
**症状**:
- ログイン後すぐにログアウトされる
- セッションが保持されない

**確認手順**:
1. セッションストアの設定を確認
   ```ruby
   # config/initializers/session_store.rb
   Rails.application.config.session_store :redis_store,
     servers: ["redis://localhost:6379/0/session"],
     expire_after: 24.hours,
     key: "_#{Rails.application.class.module_parent_name}_session"
   ```
2. セッション作成のロジックを確認
   ```ruby
   # app/controllers/users/passwordless_sessions_controller.rb
   def create
     self.resource = resource_class.find_by(email: params[:user][:email])
     if resource && resource.token_valid?
       sign_in(resource)
       redirect_to root_path
     else
       redirect_to new_user_passwordless_session_path, alert: '認証に失敗しました'
     end
   end
   ```

**解決策**:
- セッションストアの再設定
- セッション作成ロジックの見直し
- Redisの接続確認

### フラッシュメッセージが表示されない
**症状**:
- エラーメッセージが表示されない
- 成功メッセージが表示されない

**確認手順**:
1. レイアウトファイルの確認
   ```erb
   # app/views/layouts/application.html.erb
   <% flash.each do |name, msg| %>
     <div class="alert alert-<%= name == 'notice' ? 'success' : 'danger' %>">
       <%= msg %>
     </div>
   <% end %>
   ```
2. フラッシュメッセージの設定を確認
   ```ruby
   # app/controllers/users/passwordless_sessions_controller.rb
   def create
     # ...
     flash[:notice] = '認証メールを送信しました'
     # ...
   end
   ```

**解決策**:
- レイアウトファイルの修正
- フラッシュメッセージの設定見直し
- スタイルの確認

### メーラーのテストが失敗する
**症状**:
- メーラーのテストが失敗する
- テストカバレッジが低い

**確認手順**:
1. テスト環境の設定を確認
   ```ruby
   # config/environments/test.rb
   config.action_mailer.delivery_method = :test
   config.action_mailer.default_url_options = { host: 'localhost:3000' }
   ```
2. テストヘルパーの確認
   ```ruby
   # spec/rails_helper.rb
   config.include Devise::Test::ControllerHelpers, type: :controller
   config.include Devise::Test::IntegrationHelpers, type: :request
   ```
3. メーラーのテストを確認
   ```ruby
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

**解決策**:
- テスト環境の設定見直し
- テストヘルパーの追加
- テストケースの見直し 