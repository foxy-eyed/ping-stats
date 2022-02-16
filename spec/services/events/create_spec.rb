# frozen_string_literal: true

describe Events::Create do
  it "persists events" do
    service = described_class.new
    service.call(ip: "8.8.8.8", event_name: :host_added)
    service.call(ip: "8.8.8.8", event_name: :host_removed)

    inserted_rows_count = ClickHouse.connection.select_value(
      "SELECT COUNT(*) FROM #{ENV.fetch('CLICKHOUSE_TABLE_NAME', 'events')} WHERE ip = toIPv4('8.8.8.8')"
    )

    expect(inserted_rows_count).to eq(2)
  end
end
