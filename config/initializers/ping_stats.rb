# frozen_string_literal: true

module PingStats
  class << self
    def ip_storage
      @ip_storage ||= PingStats::IpStorage.new
    end

    def events_storage
      @events_storage ||= PingStats::EventsStorage.new
    end
  end
end
