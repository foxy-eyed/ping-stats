# frozen_string_literal: true

module PingStats
  class API < Grape::API
    version "v1", using: :path
    prefix :api
    format :json

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
          { status: :error, message: result.error }
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
          { status: :error, message: result.error }
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
          { status: :error, message: result.error }
        end
      end
    end
  end
end
