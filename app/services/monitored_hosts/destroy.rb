# frozen_string_literal: true

module MonitoredHosts
  class Destroy
    def call(ip:)
      if PingStats.storage.monitored?(ip)
        PingStats.storage.remove(ip)
        Events::Create.new.call(ip: ip, event_name: :host_removed)
        Result::Success.new
      else
        Result::Failure.new("Given IP address does not exist")
      end
    end
  end
end
