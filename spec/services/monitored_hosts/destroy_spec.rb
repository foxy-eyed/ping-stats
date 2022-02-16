# frozen_string_literal: true

describe MonitoredHosts::Destroy do
  subject(:destroy_host) { described_class.new.call(ip: ip) }

  let(:ip) { "8.8.8.8" }

  context "with existed ip" do
    before { PingStats.storage.add(ip) }

    it "returns success result" do
      expect(destroy_host).to be_success
    end

    it "removes ip address from monitoring" do
      destroy_host
      expect(PingStats.storage).not_to be_monitored(ip)
    end
  end

  context "with unknown ip" do
    it "returns failure" do
      expect(destroy_host).to be_failure
    end

    it "contains correct error message" do
      expect(destroy_host.error).to eq("Given IP address does not exist")
    end
  end
end
