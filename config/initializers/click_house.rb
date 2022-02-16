# frozen_string_literal: true

ClickHouse.config do |config|
  clickhouse_url = ENV.fetch("CLICKHOUSE_URL", "http://default:@localhost:8123/ping_stats")
  uri = URI.parse(clickhouse_url)

  config.assign(
    scheme: uri.scheme,
    host: uri.host,
    port: uri.port,
    username: uri.user,
    password: uri.password,
    database: uri.path.sub(%r{\A/}, "")
  )
end
