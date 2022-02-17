# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.1.0"

gem "click_house"
gem "dotenv"
gem "grape"
gem "grape-swagger"
gem "net-ping"
gem "puma"
gem "rack"
gem "rake"
gem "redis"
gem "sidekiq"
gem "sidekiq-scheduler"

group :development, :test do
  gem "rubocop", require: false
  gem "rubocop-rspec"
end

group :test do
  gem "mock_redis"
  gem "rack-test"
  gem "rspec"
  gem "simplecov", require: false
end
