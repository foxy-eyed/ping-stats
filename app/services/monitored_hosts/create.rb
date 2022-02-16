# frozen_string_literal: true

module MonitoredHosts
  class Create
    def call(ip:)
      if PingStats.storage.monitored?(ip)
        Result::Failure.new("IP address already monitored")
      else
        PingStats.storage.add(ip)
        Events::Create.new.call(ip: ip, event_name: :host_added)
        Result::Success.new
      end
    end
  end
end
