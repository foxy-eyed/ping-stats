# frozen_string_literal: true

module ResetClickhouse
  def reset_clickhouse!
    ClickHouse.connection.truncate_table(ENV.fetch("CLICKHOUSE_TABLE_NAME", "events"))
  end
end
