# frozen_string_literal: true

module MonitoredHosts
  class PingJob < BaseJob
    def perform(ip)
      MonitoredHosts::Ping.new.call(ip: ip)
    end
  end
end
