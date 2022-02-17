# frozen_string_literal: true

module EventsPopulator
  extend ActiveSupport::Concern

  included do
    before do
      allow(Time).to receive(:now).and_return(current_time)
    end
  end

  def setup_events_table(ip:, latencies: [], failures_count: 0)
    event_creator = Events::Create.new
    latencies.each { |latency| event_creator.call(ip: ip, event_name: :ping_succeed, latency: latency) }
    failures_count.times { event_creator.call(ip: ip, event_name: :ping_failed, error_message: "execution expired") }
  end
end
