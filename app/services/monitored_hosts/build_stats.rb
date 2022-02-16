# frozen_string_literal: true

module MonitoredHosts
  class BuildStats
    def call(ip:, interval_start:, interval_end:)
      return Result::Failure.new("Given IP address does not exist") unless PingStats.storage.monitored?(ip)

      Result::Success.new({})
    end
  end
end
