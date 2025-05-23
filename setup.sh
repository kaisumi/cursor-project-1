#!/bin/bash
set -e

# Railsアプリケーションの初期化
docker-compose run --rm web rails new . --force --database=postgresql --skip-git

# 権限の修正
sudo chown -R $USER:$USER .

# Gemfileの更新（既存のGemfileを使用）
cp Gemfile.new Gemfile
docker-compose run --rm web bundle install

# データベースの設定
docker-compose run --rm web rails db:create
docker-compose run --rm web rails db:migrate

# Deviseのインストール
docker-compose run --rm web rails generate devise:install
docker-compose run --rm web rails generate devise User
docker-compose run --rm web rails db:migrate

# Tailwind CSSのインストール
docker-compose run --rm web rails tailwindcss:install

# RSpecのセットアップ
docker-compose run --rm web rails generate rspec:install

# Rubocopの設定ファイルの作成
cat > .rubocop.yml << EOL
require:
  - rubocop-rails
  - rubocop-rspec

AllCops:
  NewCops: enable
  TargetRubyVersion: 3.4
  Exclude:
    - 'bin/**/*'
    - 'db/**/*'
    - 'config/**/*'
    - 'node_modules/**/*'
    - 'vendor/**/*'
    - '.git/**/*'
EOL

echo "セットアップが完了しました！"