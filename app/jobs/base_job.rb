# frozen_string_literal: true

class BaseJob
  include Sidekiq::Job

  sidekiq_options retry: false
end
