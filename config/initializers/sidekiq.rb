# frozen_string_literal: true

DEFAULT_REDIS_URL = "redis://127.0.0.1:6379"
DB_KEY = 0

redis = { url: ENV.fetch("REDIS_URL", DEFAULT_REDIS_URL), db: DB_KEY }

Sidekiq.configure_client do |config|
  config.redis = redis
end

Sidekiq.configure_server do |config|
  config.redis = redis
end
