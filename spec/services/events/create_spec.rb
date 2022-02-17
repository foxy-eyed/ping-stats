# frozen_string_literal: true

describe Events::Create do
  subject(:create_event) { described_class.new.call(ip: "8.8.8.8", event_name: :host_added) }

  it "returns success result" do
    expect(create_event).to be_success
  end

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

  context "when insert failed" do
    before do
      allow(PingStats.events_storage).to receive(:create).and_raise(PingStats::EventsStorage::Error, "Oh-oh!")
    end

    it "returns failure" do
      expect(create_event).to be_failure
    end

    it "contains correct error message" do
      expect(create_event.error).to eq("Oh-oh!")
    end
  end
end
