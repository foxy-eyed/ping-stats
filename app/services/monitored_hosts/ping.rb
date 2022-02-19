# frozen_string_literal: true

module MonitoredHosts
  class PingFailure < StandardError; end

  class Ping
    DEFAULT_PING_TIMEOUT = 5

    def call(ip:)
      client = Net::Ping::ICMP.new(ip, nil, ENV.fetch("PING_TIMEOUT", DEFAULT_PING_TIMEOUT))
      raise PingFailure, client.exception.message unless client.ping?

      Events::Create.new.call(ip: ip, event_name: :ping_succeed, latency: client.duration)
    rescue Errno::EHOSTUNREACH, PingFailure => e
      Events::Create.new.call(ip: ip, event_name: :ping_failed, error_message: e.message)
    end
  end
end
