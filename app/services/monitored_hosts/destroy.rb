# frozen_string_literal: true

module MonitoredHosts
  class Destroy
    def call(ip:)
      PingStats.storage.remove(ip)
    end
  end
end
