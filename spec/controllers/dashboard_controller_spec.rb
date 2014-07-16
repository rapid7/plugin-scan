require 'spec_helper'

describe DashboardController do
  before do
    Timecop.freeze(Time.local(2013, 01, 14, 10, 0, 0))
  end

  after do
    Timecop.return
  end

  let(:user) { create(:user) }
  before { sign_in user }

  describe "#index" do
    let(:feed) { double(:feed) }
    before { UseCases::FindsFeed.stub(find_for_user: feed) }

    it "makes the dashboard navigation active" do
      get :index
      expect(assigns(:dashboard_nav)).to eq('active')
    end

    it "finds the feed for the current user" do
      UseCases::FindsFeed.should_receive(:find_for_user).with(user)
      get :index
    end

    it "creates a presenter with the user feed and a duration of 30 days" do
      DashboardPagePresenter.should_receive(:new).with(feed: feed, days: 30)
      get :index
    end

    it "assigns @presenter" do
      presenter = double(:presenter)
      DashboardPagePresenter.stub(:new) { presenter }
      get :index
      expect(assigns(:presenter)).to eq(presenter)
    end
  end

  describe "#graph" do
    let(:start_time) { (Time.now.utc - 2.days).beginning_of_day }
    let(:end_time) { Time.now.utc.end_of_day }
    let(:feed_id) { '12345' }
    let!(:feed) { Feed.create(fid: feed_id, user_id: user.id) } 

    context "for traffic analysis" do 
      let(:traffic) { double(:traffic) }
      let(:duration) { double(:double) }

      before do
        Duration.stub(:between).with(start_time, end_time) { duration }
        UseCases::FindsTraffic.stub(:find_for).with(feed, duration) { traffic } 
        get :graph, fid: feed_id,
                    graph: 'statistics-traffic-tab',
                    duration_ts: start_time.to_i,
                    duration_te: end_time.to_i
      end

      it "finds traffic for the given feed and duration" do
        expect(assigns(:traffic)).to eq(traffic)
      end

      it "renders traffic_total partial" do
        expect(response).to render_template('dashboard/charts/_traffic_total')
      end
    end

    context "browser addons" do 
      before do
        stat = DailyStats.create(fid: feed_id, date: 1.day.ago.to_date)
        stat.add_to_set(:addons, { 'name' => 'java', 'count' => 1 })
        stat.add_to_set(:java, {
          "os"=>"macintosh", "browser"=>"chrome", "version"=>"1.1.0.0", "count"=>1, "outdated"=>false
        })

        stat = DailyStats.create(fid: feed_id, date: Time.now.utc.to_date)
        stat.add_to_set(:addons, { 'name' => 'java', 'count' => 2 })
        stat.add_to_set(:java, {
          "os"=>"macintosh", "browser"=>"chrome", "version"=>"1.0.0.0", "count"=>2, "outdated"=>true
        })

        get :graph, fid: feed_id,
                    graph: 'statistics-java-tab',
                    duration_ts: start_time.to_i,
                    duration_te: end_time.to_i
      end

      it "renders traffic_total partial" do
        expect(response).to render_template('dashboard/charts/_addon_total')
      end

      it "returns no results for 1/12" do
        expect(assigns(:hits_daily_data)).to include("['1/12', 0, 0]")
      end

      it "returns one java hit for 1/13" do
        expect(assigns(:hits_daily_data)).to include("['1/13', 1, 0]")
      end

      it "returns one java hit and one exploitable result for 1/14" do
        expect(assigns(:hits_daily_data)).to include("['1/14', 2, 2]")
      end

      it "assigns the traffic days" do
        expect(assigns(:traffic_dates)).to eq("'1/12', '1/13', '1/14'")
      end

      it "assigns the traffic hit data" do
        expect(assigns(:traffic_hits_data)).to eq("0, 1, 2")
      end

      it "assigns the traffic exploitable data" do
        expect(assigns(:traffic_exploitable_data)).to eq("0, 0, 2")
      end

      it "assigns the addon name" do
        expect(assigns(:addon_name)).to eq("Oracle Java")
      end

      it "assigns the addon stats" do
        data = assigns(:addon_data)
        expect(data).to include("['Oracle Java 1.0.0.0', 2]")
        expect(data).to include("['Oracle Java 1.1.0.0', 1]")
      end

      it "assigns the addon exploitable stats" do
        expect(assigns(:addon_exploitable)).to eq("['Current', 1], ['Outdated', 2]")
      end
    end

    context "operating systems" do 
      before do
        DailyStats.create(fid: feed_id, date: 2.days.ago.to_date)
                  .set(:oses, [{"os"=>"macintosh", "count"=>1}])
        DailyStats.create(fid: feed_id, date: 1.day.ago.to_date)
                  .set(:oses, [{"os"=>"linux", "count"=>2}])
        DailyStats.create(fid: feed_id, date: Time.now.utc.to_date)
                  .set(:oses, [{"os"=>"ubuntu", "count"=>3}])

        get :graph, fid: feed_id,
                    graph: 'statistics-os-tab',
                    duration_ts: start_time.to_i,
                    duration_te: end_time.to_i
      end

      it "renders os_total partial" do
        expect(response).to render_template('dashboard/charts/_os_total')
      end

      it "returns a hit for macintosh" do
        expect(assigns(:os)).to include("['Mac OS X', 1]")
      end

      it "returns a hit for linux" do
        expect(assigns(:os)).to include("['Linux (Other)', 2],")
      end

      it "returns a hit for ubuntu" do
        expect(assigns(:os)).to include("['Linux (Ubuntu)', 3],")
      end

      it "assigns the os names" do
        expect(assigns(:os_chart_names)).to eq("'Linux (Ubuntu)', 'Linux (Other)', 'Mac OS X'")
      end

      it "assigns the os counts" do
        expect(assigns(:os_chart_count)).to eq("3, 2, 1")
      end
    end

    context "web browsers" do 
      before do
        UseCases::FindsBrowserStats.stub_chain(:new, :find_stats).and_return([
          double(:value => 'firefox', :count => 1),
          double(:value => 'chrome', :count => 1),
          double(:value => 'safari', :count => 1)
        ])

        get :graph, fid: feed_id,
                    graph: 'statistics-browser-tab',
                    duration_ts: start_time.to_i,
                    duration_te: end_time.to_i
      end

      it "renders browser_total partial" do
        expect(response).to render_template('dashboard/charts/_browser_total')
      end

      it "returns a hit for safari" do
        expect(assigns(:browsers)).to include("['Apple Safari', 1]")
      end

      it "returns a hit for chrome" do
        expect(assigns(:browsers)).to include("['Google Chrome', 1],")
      end

      it "returns a hit for firefox" do
        expect(assigns(:browsers)).to include("['Mozilla Firefox', 1],")
      end

      it "assigns the browsers names" do
        expect(assigns(:browser_chart_names)).to eq("'Mozilla Firefox', 'Google Chrome', 'Apple Safari'")
      end

      it "assigns the browser counts" do
        expect(assigns(:browser_chart_count)).to eq("1, 1, 1")
      end
    end
    
    context "websites" do 
      before do
        DailyStats.create(fid: feed_id, date: 2.days.ago.to_date)
                  .add_to_set(:referrers, { 'host' => 'host1', 'count' => 1 })

        DailyStats.create(fid: feed_id, date: 1.day.ago.to_date)
                  .add_to_set(:referrers, { 'host' => 'host2', 'count' => 3 })

        DailyStats.create(fid: feed_id, date: Time.now.utc.to_date)
                  .add_to_set(:referrers, { 'host' => 'host3', 'count' => 2 })

        get :graph, fid: feed_id,
                    graph: 'websites-all-tab',
                    duration_ts: start_time.to_i,
                    duration_te: end_time.to_i
      end

      it "renders websites_all_tab partial" do
        expect(response).to render_template('dashboard/_websites_all_tab')
      end

      it "returns three hits" do
        expect(assigns(:referers).size).to eq(3)
      end

      it "returns a hit for host1" do
        expect(assigns(:referers)['host1']).to eq(1)
      end

      it "returns hits for host2" do
        expect(assigns(:referers)['host2']).to eq(3)
      end

      it "returns hits for host3" do
        expect(assigns(:referers)['host3']).to eq(2)
      end

      it "returns an ordered hit count" do
        expect(assigns(:referers).values).to eq([3, 2, 1])
      end
    end

    context "unique ips" do 
      before do
        DailyStats.create(fid: feed_id, date: 2.days.ago.to_date)
                  .add_to_set(:ip_addresses, { 'ip' => '192.168.1.10', 'count' => 1 })

        DailyStats.create(fid: feed_id, date: 1.day.ago.to_date)
                  .add_to_set(:ip_addresses, { 'ip' => '127.0.0.1', 'count' => 3 })

        DailyStats.create(fid: feed_id, date: Time.now.utc.to_date)
                  .add_to_set(:ip_addresses, { 'ip' => '192.168.1.11', 'count' => 2 })

        get :graph, fid: feed_id,
                    graph: 'sources-all-tab',
                    duration_ts: start_time.to_i,
                    duration_te: end_time.to_i
      end

      it "renders sources_all_tab partial" do
        expect(response).to render_template('dashboard/_sources_all_tab')
      end

      it "returns three hits" do
        expect(assigns(:ips).size).to eq(3)
      end

      it "returns a hit for 192.168.1.10" do
        expect(assigns(:ips)['192.168.1.10']).to eq(1)
      end

      it "returns hits for 127.0.0.1" do
        expect(assigns(:ips)['127.0.0.1']).to eq(3)
      end

      it "returns hits for 192.168.1.11" do
        expect(assigns(:ips)['192.168.1.11']).to eq(2)
      end

      it "returns an ordered hit count" do
        expect(assigns(:ips).values).to eq([3, 2, 1])
      end
    end

    context "world map" do 
      before do
        DailyStats.create(fid: feed_id, date: 2.days.ago.to_date)
                  .add_to_set(:countries, { 'country' => 'US', 'outdated_count' => 2 })

        DailyStats.create(fid: feed_id, date: 1.day.ago.to_date)
                  .add_to_set(:countries, { 'country' => 'FR', 'outdated_count' => 1 })

        DailyStats.create(fid: feed_id, date: Time.now.utc.to_date)
                  .add_to_set(:countries, { 'country' => 'CA', 'outdated_count' => 3 })

        get :graph, fid: feed_id,
                    graph: 'map-world-tab',
                    duration_ts: start_time.to_i,
                    duration_te: end_time.to_i
      end

      it "renders sources_all_tab partial" do
        expect(response).to render_template('dashboard/_map_world')
      end

      it "returns a result for CA" do
        expect(assigns(:map_data)).to include("['CA', 3],")
      end

      it "returns a result for US" do
        expect(assigns(:map_data)).to include("['US', 2],")
      end

      it "returns a result for FR" do
        expect(assigns(:map_data)).to include("['FR', 1]")
      end

    end

    context "exploitable tab" do 
      let!(:exploit1) { Exploitable.create!(fid: feed_id, created_at: 1.day.ago) }
      let!(:exploit2) { Exploitable.create!(fid: feed_id) }

      context "all" do
        before do
          get :graph, fid: feed_id,
                      graph: 'exploitable-all-tab',
                      duration_ts: start_time.to_i,
                      duration_te: end_time.to_i
        end

        it "renders sources_all_tab partial" do
          expect(response).to render_template('dashboard/_exploitable_all_tab')
        end

        it "returns two results" do
          expect(assigns(:exploitable_hosts).size).to eq(2)
        end

        it "returns exploits ordered by most recent first" do
          hosts = assigns(:exploitable_hosts)
          hosts.each_with_index do |host, i|
            if i == 0
              expect(host).to eq(exploit2)
            else
              expect(host).to eq(exploit1)
            end
          end
        end
      end

      context "addon" do
        before do
          get :graph, fid: feed_id,
                      graph: 'exploitable-java-tab',
                      duration_ts: start_time.to_i,
                      duration_te: end_time.to_i
        end

        it "returns two results" do
          expect(assigns(:exploitable_hosts).size).to eq(2)
        end

        it "assigns the addon id" do
          expect(assigns(:addon_id)).to eq("java")
        end

        it "assigns the addon name" do
          expect(assigns(:addon_name)).to eq("Oracle Java")
        end
      end
    end
  end
end
