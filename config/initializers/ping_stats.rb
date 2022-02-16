# frozen_string_literal: true

module PingStats
  class << self
    def storage
      @storage ||= PingStats::RedisStorage.new
    end
  end
end
