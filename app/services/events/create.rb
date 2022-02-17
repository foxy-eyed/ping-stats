# frozen_string_literal: true

module Events
  class Create
    def call(ip:, event_name:, latency: nil, error_message: nil)
      PingStats.events_storage.create(ip: ip,
                                      event_time: Time.now.utc.to_i,
                                      event_name: event_name,
                                      latency: latency,
                                      error_message: error_message)
      Result::Success.new
    rescue PingStats::EventsStorage::Error => e
      Result::Failure.new(e.message)
    end
  end
end
