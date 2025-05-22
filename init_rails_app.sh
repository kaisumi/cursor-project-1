#!/bin/bash
set -e

rails new . --database=postgresql --skip-git --skip-test --skip-bundle --skip-javascript --skip-jbuilder --skip-action-mailbox --skip-action-text --skip-system-test --skip-bootsnap --skip-active-storage

bundle install

rails tailwindcss:install

rails turbo:install
rails stimulus:install

rails generate rspec:install

mkdir -p spec/factories
touch spec/factories/.keep

rails db:create
rails db:migrate

rails generate model User email:string:uniq name:string
rails db:migrate

rails generate controller Auth login logout verify --skip-routes

mkdir -p .github/workflows
