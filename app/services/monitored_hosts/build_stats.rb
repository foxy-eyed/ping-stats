# frozen_string_literal: true

module MonitoredHosts
  class BuildStats
    def call(ip:, interval_start:, interval_end:)
      return Result::Failure.new("Given IP address does not exist") unless PingStats.ip_storage.monitored?(ip)

      data = PingStats.events_storage.aggregate_ping_stats(ip, interval_start, interval_end)
      return Result::Failure.new("Empty stats") if empty?(data)

      Result::Success.new(build_stats(data))
    end

    private

    def empty?(data)
      (data["ping_succeed"] + data["ping_failed"]).zero?
    end

    def build_stats(data)
      {
        min_rtt: data["min_rtt"],
        max_rtt: data["max_rtt"],
        avg_rtt: data["avg_rtt"],
        median_rtt: data["median_rtt"],
        std_dev: data["std_dev"],
        loss_percentage: 100.0 * data["ping_failed"] / (data["ping_failed"] + data["ping_succeed"])
      }
    end
  end
end
