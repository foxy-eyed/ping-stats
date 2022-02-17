# frozen_string_literal: true

describe "Remove IP from monitoring", type: :request do
  subject(:remove_ip) { delete route, params: { ip: ip } }

  let(:route) { "/api/v1/monitored_hosts/" }

  context "with valid IP" do
    let(:ip) { "8.8.8.8" }

    before { PingStats.ip_storage.add(ip) }

    it "responds with 200" do
      remove_ip
      expect(response_status).to eq(200)
    end

    it "renders correct json body" do
      remove_ip
      expect(response_json).to eq({ "status" => "success", "message" => "Host removed" })
    end
  end

  context "with valid unknown IP" do
    let(:ip) { "8.8.8.8" }

    it "responds with 422" do
      remove_ip
      expect(response_status).to eq(422)
    end

    it "renders correct json body" do
      remove_ip
      expect(response_json).to eq({ "status" => "error", "message" => "Given IP address does not exist" })
    end
  end

  context "with invalid IP" do
    let(:ip) { "5555.8.8.8" }

    it "responds with 422" do
      remove_ip
      expect(response_status).to eq(422)
    end

    it "renders correct json body" do
      remove_ip
      expect(response_json).to eq({ "status" => "error", "message" => "ip must be an IPv4 address" })
    end
  end
end
