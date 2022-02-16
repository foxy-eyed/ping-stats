# frozen_string_literal: true

describe MonitoredHosts::Create do
  subject(:create_host) { described_class.new.call(ip: ip) }

  let(:ip) { "8.8.8.8" }
  let(:event_creation_service) { instance_double(Events::Create) }

  before do
    allow(event_creation_service).to receive(:call)
    allow(Events::Create).to receive(:new).and_return(event_creation_service)
  end

  context "with new ip" do
    it "returns success result" do
      expect(create_host).to be_success
    end

    it "makes ip address monitored" do
      create_host
      expect(PingStats.storage).to be_monitored(ip)
    end

    it "invokes event creation with correct args" do
      create_host
      expect(event_creation_service).to have_received(:call).with(ip: ip, event_name: :host_added)
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

    it "does not invoke event creation" do
      create_host
      expect(event_creation_service).not_to have_received(:call)
    end
  end
end
