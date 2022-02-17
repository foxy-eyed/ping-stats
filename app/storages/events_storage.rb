# frozen_string_literal: true

module PingStats
  class EventsStorage
    class Error < StandardError; end

    DEFAULT_TABLE_NAME = "events"
    DT_FORMAT = "%Y-%m-%d %H:%M:%S"

    delegate :select_one, :insert, :truncate_table, to: :connection

    def create(event)
      insert(table, values: [event])
    rescue ClickHouse::DbException => e
      raise Error, e.message
    end

    def aggregate_ping_stats(ip, interval_start, interval_end)
      sql = <<-SQL
        SELECT
          minOrNullIf(latency, event_name = 'ping_succeed') as min_rtt,
          maxOrNullIf(latency, event_name = 'ping_succeed') as max_rtt,
          avgOrNullIf(latency, event_name = 'ping_succeed') as avg_rtt,
          quantileExactOrNullIf(latency, event_name = 'ping_succeed') as median_rtt,
          stddevSampOrNullIf(latency, event_name = 'ping_succeed') as std_dev,
          countIf(event_name = 'ping_succeed') as ping_succeed,
          countIf(event_name = 'ping_failed') as ping_failed
        FROM #{table}
        WHERE ip = toIPv4('#{ip}')
          AND event_time BETWEEN '#{interval_start.strftime(DT_FORMAT)}' AND '#{interval_end.strftime(DT_FORMAT)}'
        FORMAT JSON
      SQL

      select_one(sql)
    end

    def reset!
      truncate_table(table)
    end

    def table
      @table ||= ENV.fetch("CLICKHOUSE_TABLE_NAME", DEFAULT_TABLE_NAME)
    end

    private

    def connection
      @connection ||= ClickHouse.connection
    end
  end
end
