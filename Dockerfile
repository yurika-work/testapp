# FROM：使用するイメージ、バージョン
FROM ruby:3.2.2
# 公式→https://hub.docker.com/_/ruby

ENV RAILS_ENV=production

# ruby3.1のイメージがBundler version 2.3.7で失敗するので、gemのバージョンを追記
ARG RUBYGEMS_VERSION=3.2.2

# RUN：任意のコマンド実行
RUN mkdir /app

# WORKDIR：作業ディレクトリを指定
WORKDIR /app

# COPY：コピー元とコピー先を指定
# ローカルのGemfileをコンテナ内の/app/Gemfileに
COPY Gemfile /app/Gemfile

COPY Gemfile.lock /app/Gemfile.lock

# RubyGemsをアップデート
RUN bundle install

COPY . /app

RUN cd app
# 取得したmaster.keyの内容をRAILS_MASTER_KEY環境変数に入れる
ARG MASTER_KEY
ENV RAILS_MASTER_KEY=${MASTER_KEY}
RUN bundle exec rails assets:precompile RAILS_ENV=production
RUN cd ..

EXPOSE 8080
ENV PORT=8080

CMD bundle exec rails s -p $PORT