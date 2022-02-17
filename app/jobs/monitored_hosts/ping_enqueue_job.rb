# frozen_string_literal: true

module MonitoredHosts
  class PingEnqueueJob < BaseJob
    JOBS_BATCH_SIZE = 1_000 # as recommended https://github.com/mperham/sidekiq/wiki/Bulk-Queueing

    def perform
      PingStats.ip_storage.each_batch do |batch|
        batch.each_slice(JOBS_BATCH_SIZE) do |ips|
          args = ips.map { |ip| [ip] }
          MonitoredHosts::PingJob.perform_bulk(args)
        end
      end
    end
  end
end
