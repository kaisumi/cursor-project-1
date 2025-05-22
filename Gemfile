source "https://rubygems.org"

ruby "3.2.2"

# Rails
gem "rails", "~> 7.1.0"

# Database
gem "pg", "~> 1.5"

# Web server
gem "puma", "~> 6.0"

# Frontend
gem "sprockets-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"

# Authentication
gem "jwt"
gem "bcrypt"

# Caching and background jobs
gem "redis", "~> 5.0"
gem "sidekiq", "~> 7.0"

# Monitoring and error reporting
gem "sentry-ruby"
gem "sentry-rails"

# Development and testing
group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "brakeman", require: false
  gem "bundler-audit", require: false
end

group :development do
  gem "web-console"
  gem "rack-mini-profiler"
  gem "spring"
  gem "letter_opener"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "webmock"
  gem "vcr"
end
