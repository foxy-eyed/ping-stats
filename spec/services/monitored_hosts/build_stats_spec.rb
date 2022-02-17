# frozen_string_literal: true

describe MonitoredHosts::BuildStats do
  include EventsPopulator

  subject(:build_stats) do
    described_class.new.call(ip: ip, interval_start: Time.now.utc - 3600, interval_end: Time.now.utc)
  end

  let(:ip) { "8.8.8.8" }
  let(:current_time) { Time.parse("2022-02-16 10:00:00") }

  context "when ip is not added to monitoring" do
    it "returns failure" do
      expect(build_stats).to be_failure
    end

    it "contains correct error message" do
      expect(build_stats.error).to eq("Given IP address does not exist")
    end
  end

  context "when stats is empty" do
    before do
      PingStats.ip_storage.add(ip)
      setup_events_table(ip: ip)
    end

    it "returns failure" do
      expect(build_stats).to be_failure
    end

    it "contains correct error message" do
      expect(build_stats.error).to eq("Empty stats")
    end
  end

  context "when stats is present" do
    before do
      PingStats.ip_storage.add(ip)
      setup_events_table(ip: ip, latencies: [0.1, 0.2, 0.3, 0.2], failures_count: 1)
    end

    it "returns success" do
      expect(build_stats).to be_success
    end

    it "calculates correct stats" do
      expected_stats = { avg_rtt: 0.2,
                         loss_percentage: 20.0,
                         max_rtt: 0.3,
                         median_rtt: 0.2,
                         min_rtt: 0.1,
                         std_dev: 0.08164965808869012 }
      expect(build_stats.value).to eq(expected_stats)
    end
  end

  context "when stats includes only failures" do
    before do
      PingStats.ip_storage.add(ip)
      setup_events_table(ip: ip, failures_count: 1)
    end

    it "returns success" do
      expect(build_stats).to be_success
    end

    it "builds correct stats" do
      expected_stats = { avg_rtt: nil,
                         loss_percentage: 100.0,
                         max_rtt: nil,
                         median_rtt: nil,
                         min_rtt: nil,
                         std_dev: nil }
      expect(build_stats.value).to eq(expected_stats)
    end
  end
end
