# frozen_string_literal: true

describe Events::Create do
  it "persists events" do
    service = described_class.new
    events = [{ event_name: :host_added },
              { event_name: :ping_succeed, latency: 0.05 },
              { event_name: :ping_failed, error_message: "execution expired" },
              { event_name: :host_removed }]
    events.each { |attrs| service.call(ip: "8.8.8.8", **attrs) }

    inserted_rows_count = ClickHouse.connection.select_value(
      "SELECT COUNT(*) FROM #{PingStats.events_storage.table} WHERE ip = toIPv4('8.8.8.8')"
    )

    expect(inserted_rows_count).to eq(4)
  end
end
