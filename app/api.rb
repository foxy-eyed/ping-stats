# frozen_string_literal: true

module PingStats
  class API < Grape::API
    version "v1", using: :path
    prefix :api
    format :json

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error!({ status: :error, message: e.message }, 422)
    end

    resource :monitored_hosts do
      desc "Add host to monitoring"
      params do
        requires :ip, type: String, ipv4: true, desc: "Host IP"
      end
      post do
        result = MonitoredHosts::Create.new.call(ip: params[:ip])
        if result.success?
          { status: :success, message: "Host added" }
        else
          error!({ status: :error, message: result.error }, 422)
        end
      end

      desc "Remove host from monitoring"
      params do
        requires :ip, type: String, ipv4: true, desc: "Host IP"
      end
      delete do
        result = MonitoredHosts::Destroy.new.call(ip: params[:ip])
        if result.success?
          { status: :success, message: "Host removed" }
        else
          error!({ status: :error, message: result.error }, 422)
        end
      end

      desc "Show host stats"
      params do
        requires :ip, type: String, ipv4: true, desc: "Host IP"
        requires :interval_start, type: DateTime, desc: "Beginning of time interval"
        requires :interval_end, type: DateTime, desc: "End of time interval"
      end
      get :stats do
        result = MonitoredHosts::BuildStats.new.call(ip: params[:ip],
                                                     interval_start: params[:interval_start],
                                                     interval_end: params[:interval_end])
        if result.success?
          { status: :success, stats: result.value }
        else
          error!({ status: :error, message: result.error }, 422)
        end
      end
    end
  end
end
