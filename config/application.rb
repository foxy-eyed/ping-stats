# frozen_string_literal: true

require_relative "environment"
require_relative "boot"

module PingStats
  class App
    def call(env)
      if env["REQUEST_PATH"] == "/documentation"
        PingStats::RapiDoc.new.call(env)
      else
        PingStats::API.new.call(env)
      end
    end
  end
end
