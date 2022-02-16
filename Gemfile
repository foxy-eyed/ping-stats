# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.1.0"

gem "dotenv"
gem "grape"
gem "puma"
gem "rack"
gem "redis"

group :development, :test do
  gem "rubocop", require: false
  gem "rubocop-rspec"
end

group :test do
  gem "mock_redis"
  gem "rspec"
end
