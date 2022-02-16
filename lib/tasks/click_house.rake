# frozen_string_literal: true

namespace :click_house do
  task :setup do
    database = ClickHouse.config.database
    table_name = ENV.fetch("CLICKHOUSE_TABLE_NAME", "events")

    puts "Creating database `#{database}`..."
    ClickHouse.connection.create_database(database, if_not_exists: true)

    puts "Creating table `#{table_name}`..."
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS #{table_name} (
        ip IPv4,
        event_name LowCardinality(String),
        event_time DateTime,
        latency Decimal(8, 6),
        error_message LowCardinality(String)
      ) ENGINE = MergeTree()
      ORDER BY (ip, event_time)
    SQL
    ClickHouse.connection.execute(sql)

    puts "Done!"
  end

  task :drop do
    ClickHouse.connection.drop_database(ClickHouse.config.database, if_exists: true)
  end
end
