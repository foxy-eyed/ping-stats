# frozen_string_literal: true

module Events
  class Create
    def call(ip:, event_name:, latency: nil, error_message: nil)
      event = { ip: ip,
                event_time: Time.now.utc.to_i,
                event_name: event_name,
                latency: latency,
                error_message: error_message }
      ClickHouse.connection.insert(ENV.fetch("CLICKHOUSE_TABLE_NAME", "events"), values: [event])
      Result::Success.new
    rescue ClickHouse::DbException => e
      Result::Failure.new(e.message)
    end
  end
end
