# frozen_string_literal: true

require "simplecov_profile"
SimpleCov.start "custom_profile"

ENV["RACK_ENV"] = "test"

require "sidekiq/testing"
require File.expand_path("../config/application", __dir__)
Dir[File.expand_path("support/**/*.rb", __dir__)].each { |f| require f }

Sidekiq::Testing.fake!
PingStats::IpStorage.fake = true

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random
  Kernel.srand config.seed

  config.include ApiHelpers, type: :request

  config.before do
    PingStats.ip_storage.reset!
    PingStats.events_storage.reset!
    Sidekiq::Worker.clear_all
  end
end
