# frozen_string_literal: true

describe "Get ping stats", type: :request do
  include EventsPopulator

  subject(:get_stats) { get route }

  let(:route) { "/api/v1/monitored_hosts/stats/?#{params.to_query}" }
  let(:current_time) { Time.parse("2022-02-16 10:00:00") }

  context "with valid params" do
    let(:params) do
      {
        ip: "8.8.8.8",
        interval_start: (Time.now.utc - 3600).to_s,
        interval_end: Time.now.utc.to_s
      }
    end

    context "with not monitored IP" do
      it "responds with 422" do
        get_stats
        expect(response_status).to eq(422)
      end

      it "renders correct json body" do
        get_stats
        expect(response_json).to eq({ "status" => "error", "message" => "Given IP address does not exist" })
      end
    end

    context "when empty stats" do
      before do
        PingStats.ip_storage.add(params[:ip])
      end

      it "responds with 422" do
        get_stats
        expect(response_status).to eq(422)
      end

      it "renders correct json body" do
        get_stats
        expect(response_json).to eq({ "status" => "error", "message" => "Empty stats" })
      end
    end

    context "when stats present" do
      before do
        PingStats.ip_storage.add(params[:ip])
        setup_events_table(ip: params[:ip], latencies: [0.1, 0.2, 0.3, 0.2], failures_count: 1)
      end

      it "responds with 200" do
        get_stats
        expect(response_status).to eq(200)
      end

      it "renders correct json body" do
        get_stats
        expect(response_json).to eq(
          {
            "status" => "success",
            "stats" => { "avg_rtt" => 0.2,
                         "loss_percentage" => 20.0,
                         "max_rtt" => 0.3,
                         "median_rtt" => 0.2,
                         "min_rtt" => 0.1,
                         "std_dev" => 0.08164965808869012 }
          }
        )
      end
    end
  end

  context "with invalid params" do
    let(:params) do
      {
        ip: "3338.8.8.8",
        interval_start: "invalid",
        interval_end: "2022-02-02 22:22:22"
      }
    end

    it "responds with 422" do
      get_stats
      expect(response_status).to eq(422)
    end

    it "renders correct json body" do
      get_stats
      expect(response_json).to eq({ "status" => "error",
                                    "message" => "ip must be an IPv4 address, interval_start is invalid" })
    end
  end
end
