# frozen_string_literal: true

module ApiHelpers
  include Rack::Test::Methods

  def app
    PingStats::API
  end

  def post(route, params: {})
    super(route, params.to_json, "CONTENT_TYPE" => "application/json")
  end

  def delete(route, params: {})
    super(route, params.to_json, "CONTENT_TYPE" => "application/json")
  end

  def response_status
    last_response.status
  end

  def response_json
    JSON.parse(last_response.body)
  end
end
