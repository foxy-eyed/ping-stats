# frozen_string_literal: true

describe MonitoredHosts::Ping do
  subject(:ping_host) { described_class.new.call(ip: ip) }

  let(:ip) { "8.8.8.8" }
  let(:ping_client) { instance_double(Net::Ping::ICMP) }
  let(:event_creation_service) { instance_double(Events::Create) }

  before do
    allow(event_creation_service).to receive(:call)
    allow(Events::Create).to receive(:new).and_return(event_creation_service)
    allow(Net::Ping::ICMP).to receive(:new).and_return(ping_client)
  end

  context "when icmp clients ping succeed" do
    it "creates 'ping_succeed' event" do
      allow(ping_client).to receive(:ping?).and_return(true)
      allow(ping_client).to receive(:duration).and_return(0.01)
      ping_host

      expect(event_creation_service).to have_received(:call).with(ip: ip, event_name: :ping_succeed, latency: 0.01)
    end
  end

  context "when icmp clients ping failed with timeout error" do
    it "creates 'ping_failed' event" do
      allow(ping_client).to receive(:ping?).and_return(false)
      allow(ping_client).to receive(:exception).and_return(Timeout::Error.new("Ouch!"))
      ping_host

      expect(event_creation_service).to have_received(:call).with(ip: ip, event_name: :ping_failed,
                                                                  error_message: "Ouch!")
    end
  end
end
