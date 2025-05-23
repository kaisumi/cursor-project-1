source "https://rubygems.org"

ruby "3.4.3"

# Rails
gem "rails", "~> 8.0.2"

# Database
gem "pg", "~> 1.5"

# Web server
gem "puma", "~> 6.4"

# Assets
gem "sprockets-rails"
gem "importmap-rails"
gem "tailwindcss-rails"

# Hotwire
gem "turbo-rails"
gem "stimulus-rails"

# Authentication
gem "devise"

# Redis
gem "redis", "~> 5.0"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
