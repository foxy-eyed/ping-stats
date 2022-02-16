# frozen_string_literal: true

module MonitoredHosts
  class Create
    def call(ip:)
      PingStats.storage.add(ip)
    end
  end
end
