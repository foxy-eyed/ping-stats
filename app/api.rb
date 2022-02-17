# frozen_string_literal: true

module PingStats
  class API < Grape::API
    version "v1", using: :path
    prefix :api
    format :json

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error!({ status: :error, message: e.message }, 422)
    end

    mount ::PingStats::MonitoredHostsApi
    add_swagger_documentation mount_path: "/doc",
                              format: :json,
                              info: { title: "PingStats API" }
  end
end
