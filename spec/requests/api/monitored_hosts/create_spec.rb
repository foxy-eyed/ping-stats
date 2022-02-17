# frozen_string_literal: true

describe "Add IP to monitoring", type: :request do
  subject(:add_ip) { post route, params: { ip: ip } }

  let(:route) { "/api/v1/monitored_hosts/" }

  context "with valid IP" do
    let(:ip) { "8.8.8.8" }

    it "responds with 201" do
      add_ip
      expect(response_status).to eq(201)
    end

    it "renders correct json body" do
      add_ip
      expect(response_json).to eq({ "status" => "success", "message" => "Host added" })
    end

    context "when already exists" do
      before { PingStats.ip_storage.add(ip) }

      it "responds with 422" do
        add_ip
        expect(response_status).to eq(422)
      end

      it "renders correct json body" do
        add_ip
        expect(response_json).to eq({ "status" => "error", "message" => "IP address already monitored" })
      end
    end
  end

  context "with invalid IP" do
    let(:ip) { "5555.8.8.8" }

    it "responds with 422" do
      add_ip
      expect(response_status).to eq(422)
    end

    it "renders correct json body" do
      add_ip
      expect(response_json).to eq({ "status" => "error", "message" => "ip must be an IPv4 address" })
    end
  end
end
