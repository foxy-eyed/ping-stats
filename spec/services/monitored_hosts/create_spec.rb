# frozen_string_literal: true

describe MonitoredHosts::Create do
  subject(:create_host) { described_class.new.call(ip: ip) }

  let(:ip) { "8.8.8.8" }

  context "with new ip" do
    it "returns success result" do
      expect(create_host).to be_success
    end

    it "makes ip address monitored" do
      create_host
      expect(PingStats.storage).to be_monitored(ip)
    end
  end

  context "with existed ip" do
    before { PingStats.storage.add(ip) }

    it "returns failure" do
      expect(create_host).to be_failure
    end

    it "contains correct error message" do
      expect(create_host.error).to eq("IP address already monitored")
    end
  end
end
