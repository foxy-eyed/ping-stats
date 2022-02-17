# frozen_string_literal: true

describe MonitoredHosts::PingEnqueueJob do
  subject(:enqueue_ping_jobs) do
    described_class.perform_async
    described_class.drain
  end

  before do
    monitored_hosts.each { |ip| PingStats.ip_storage.add(ip) }
  end

  context "with monitored hosts present" do
    let(:monitored_hosts) { %w[8.8.8.8 8.8.4.4] }

    it "invokes ping worker for each monitored host" do
      expect { enqueue_ping_jobs }.to change(MonitoredHosts::PingJob.jobs, :size).from(0).to(2)
    end
  end

  context "with empty monitored hosts" do
    let(:monitored_hosts) { [] }

    it "does not invoke any ping worker" do
      expect { enqueue_ping_jobs }.not_to change(MonitoredHosts::PingJob.jobs, :size)
    end
  end
end
