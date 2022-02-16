# frozen_string_literal: true

module PingStats
  class API < Grape::API
    version "v1", using: :path
    prefix :api
    format :json

    resource :monitored_hosts do
      desc "Add host to monitoring"
      params do
        requires :ip, type: String, desc: "Host IP"
      end
      post do
        MonitoredHosts::Create.new.call(ip: params[:ip])
        { status: :success, message: "Host added" }
      end

      desc "Remove host from monitoring"
      params do
        requires :ip, type: String, desc: "Host IP"
      end
      delete do
        MonitoredHosts::Destroy.new.call(ip: params[:ip])
        { status: :success, message: "Host removed" }
      end

      desc "Show host stats"
      params do
        requires :ip, type: String, desc: "Host IP"
        requires :interval_start, type: String, desc: "Beginning of time interval"
        requires :interval_end, type: String, desc: "End of time interval"
      end
      get :stats do
        { status: :success, stats: {} }
      end
    end
  end
end
