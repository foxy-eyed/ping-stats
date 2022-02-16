# frozen_string_literal: true

describe MonitoredHosts::Destroy do
  subject(:destroy_host) { described_class.new.call(ip: ip) }

  let(:ip) { "8.8.8.8" }
  let(:event_creation_service) { instance_double(Events::Create) }

  before do
    allow(event_creation_service).to receive(:call)
    allow(Events::Create).to receive(:new).and_return(event_creation_service)
  end

  context "with existed ip" do
    before { PingStats.storage.add(ip) }

    it "returns success result" do
      expect(destroy_host).to be_success
    end

    it "removes ip address from monitoring" do
      destroy_host
      expect(PingStats.storage).not_to be_monitored(ip)
    end

    it "invokes event creation with correct args" do
      destroy_host
      expect(event_creation_service).to have_received(:call).with(ip: ip, event_name: :host_removed)
    end
  end

  context "with unknown ip" do
    it "returns failure" do
      expect(destroy_host).to be_failure
    end

    it "contains correct error message" do
      expect(destroy_host.error).to eq("Given IP address does not exist")
    end

    it "does not invoke event creation" do
      destroy_host
      expect(event_creation_service).not_to have_received(:call)
    end
  end
end
