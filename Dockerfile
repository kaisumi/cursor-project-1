FROM ruby:3.4.3

# 必要なパッケージのインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs npm && \
    npm install -g yarn

# 作業ディレクトリの設定
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile Gemfile.lock ./

# Bundlerのインストールと依存関係の解決
RUN bundle install

# アプリケーションのコードをコピー
COPY . .

# アセットのプリコンパイル
RUN bundle exec rails assets:precompile

# ポートの公開
EXPOSE 3000

# 起動コマンド
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"] 