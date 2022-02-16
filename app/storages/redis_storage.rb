# frozen_string_literal: true

module PingStats
  class RedisStorage
    DEFAULT_REDIS_URL = "redis://127.0.0.1:6379"
    DB_KEY = 1
    KEY = "ping_stats::monitored_hosts"

    cattr_accessor :fake

    def add(ip)
      redis.sadd(KEY, ip)
    end

    def remove(ip)
      redis.srem(KEY, ip)
    end

    def monitored?(ip)
      redis.sismember(KEY, ip)
    end

    def reset!
      raise "Non-fake storage cannot be reset!" unless self.class.fake

      redis.flushdb
    end

    private

    def redis
      @redis ||= if self.class.fake
                   require "mock_redis"
                   MockRedis.new
                 else
                   Redis.new(url: ENV.fetch("REDIS_URL", DEFAULT_REDIS_URL), db: DB_KEY)
                 end
    end
  end
end
