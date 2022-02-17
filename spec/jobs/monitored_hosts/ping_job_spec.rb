# frozen_string_literal: true

describe MonitoredHosts::PingJob do
  it "invokes ping service for given ip" do
    ping_service = instance_double(MonitoredHosts::Ping)
    allow(ping_service).to receive(:call)
    allow(MonitoredHosts::Ping).to receive(:new).and_return(ping_service)
    described_class.perform_async("8.8.8.8")
    described_class.drain

    expect(ping_service).to have_received(:call).with(ip: "8.8.8.8")
  end
end
