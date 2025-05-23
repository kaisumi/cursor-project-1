FROM ruby:3.4.3

# 必要なパッケージのインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs npm

# Yarnのインストール
RUN npm install -g yarn

# 作業ディレクトリの設定
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile* ./

# Bundlerのインストールとセットアップ
RUN gem install bundler -v 2.5.3
RUN bundle install

# アプリケーションのコピー
COPY . .

# エントリーポイントの設定
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Railsサーバーの起動
CMD ["rails", "server", "-b", "0.0.0.0"]