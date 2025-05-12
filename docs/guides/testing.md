# テストガイド

## 概要
このガイドでは、本プロジェクトのテスト戦略と実装方針について説明します。

## テストの種類

### 1. モデルスペック
```ruby
RSpec.describe Post, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe '#method_name' do
    context 'when condition' do
      it 'returns expected result' do
        # テストコード
      end
    end
  end
end
```

### 2. コントローラースペック
```ruby
RSpec.describe PostsController, type: :controller do
  describe 'GET #index' do
    context 'when user is signed in' do
      it 'returns success response' do
        # テストコード
      end
    end
  end
end
```

### 3. システムスペック
```ruby
RSpec.describe 'Posts', type: :system do
  describe '投稿一覧' do
    it '投稿が表示されること' do
      # テストコード
    end
  end
end
```

## テスト実装のベストプラクティス

### 1. 命名規則
- ファイル名: `{モデル名}_spec.rb`
- テストグループ: 機能や状況を説明する
- テストケース: 期待される結果を説明する

### 2. テストの構造化
- `describe`: クラス、メソッド、機能の単位
- `context`: テストの前提条件
- `it`: 具体的なテストケース

### 3. テストデータ
- FactoryBotを使用
- 必要最小限のデータを作成
- テストデータは明示的に定義

### 4. 共通化
- `shared_examples`の活用
- `shared_context`の活用
- カスタムマッチャーの作成

## テストカバレッジ

### 1. カバレッジ目標
- 全体: 90%以上
- モデル: 95%以上
- コントローラー: 90%以上
- システム: 85%以上

### 2. カバレッジレポート
- SimpleCovを使用
- CIでレポート生成
- カバレッジ低下時はCIが失敗

## CI/CDでのテスト

### 1. テストの並列実行
```yaml
rspec:
  parallel: true
  workers: 4
```

### 2. テストの分類
- 高速テスト（unit）
- 中速テスト（integration）
- 低速テスト（system）

### 3. キャッシュ戦略
- 依存関係のキャッシュ
- テスト結果のキャッシュ
- システムテストのキャッシュ

## トラブルシューティング

### 1. フレイルなテスト
- 時間依存を避ける
- データベースクリーンアップを確認
- 順序依存を避ける

### 2. パフォーマンス
- テストの実行順序の最適化
- 不要なデータ作成の回避
- データベースクリーンアップの最適化

### 3. デバッグ
- `save_and_open_page`の活用
- `binding.pry`の活用
- ログの活用

## 参考資料
- [Better Specs](https://www.betterspecs.org/)
- [RSpec Style Guide](https://rspec.rubystyle.guide/)
- [Capybara Cheat Sheet](https://devhints.io/capybara) 