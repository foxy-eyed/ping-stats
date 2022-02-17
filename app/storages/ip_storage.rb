# frozen_string_literal: true

module PingStats
  class IpStorage
    DEFAULT_REDIS_URL = "redis://127.0.0.1:6379"
    DB_KEY = 1
    KEY = "ping_stats::monitored_hosts"

    BATCH_SIZE = 100_000
    MAX_ITERATIONS = 100 # just extra protection against infinite loop; enough to process up to 1KK hosts

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

    def each_batch(&block)
      cursor = 0
      i = 0
      loop do
        cursor, batch = redis.sscan(KEY, cursor, count: BATCH_SIZE)
        break if batch.empty?

        block.call batch
        i += 1
        break if cursor == "0" || i >= MAX_ITERATIONS
      end
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
