require 'spec_helper'
# For some reason PluginScan::Software is not load when running all specs
require File.expand_path(File.dirname(__FILE__) + "/../../lib/plugin_scan/software")

describe InspectController do
  context "with a valid feed id" do
    let(:feed_id) { 'EM-612976191' }
    let(:feed) { double(:feed, fid: feed_id,
                               redirect_uri: 'http://example.com/') }
    before { UseCases::FindsFeed.stub(:find_by_id).with(feed_id) { feed } }

    context "when there is a tid" do
      let(:tid) { 'tid-12345678901234567890' }
      let(:ip_address) { '192.0.43.10' }

      before do
        subject.stub(:cookie_value_for).with(:tid) { tid } 
        request.stub(:remote_ip => ip_address)
        request.stub(:headers => {
          'HTTP_REFERER'         => 'http://example.com',
          'DNT'                  => 'do-not-track',
          'HTTP_ACCEPT_LANGUAGE' => 'en-us;',
          'HTTP_USER_AGENT'      => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.28.10 (KHTML, like Gecko) Version/6.0.3 Safari/536.28.10"
        })
      end

      context "when a new hit is added" do
        it "adds a single hit" do
          get :index, fid: feed_id
          expect(Hit.count).to eq(1)
        end

        it "uses the tid as the id" do
          get :index, fid: feed_id
          expect(Hit.first._id).to eq(tid)
        end

        it "has the feed id" do
          get :index, fid: feed_id
          expect(Hit.first.fid).to eq(feed_id)
        end

        it "has the ip address" do
          get :index, fid: feed_id
          expect(Hit.first.ip).to eq(ip_address)
        end

        it "has the country" do
          get :index, fid: feed_id
          expect(Hit.first.country).to eq('United States')
        end

        it "has the referrer host" do
          get :index, fid: feed_id
          expect(Hit.first.rf).to eq('example.com')
        end

        it "has the 'do not track'" do
          get :index, fid: feed_id
          expect(Hit.first.dnt).to eq('do-not-track')
        end

        it "has the operating system" do
          get :index, fid: feed_id
          expect(Hit.first.os).to eq('macintosh')
          expect(Hit.first.os_l).to eq('en-us')
        end

        it "has the browser" do
          get :index, fid: feed_id
          expect(Hit.first.br).to eq('safari')
          expect(Hit.first.br_v).to eq('536.28.10')
        end

        it "has the addon versions" do
          get :index, fid: feed_id, reader: '1,0', flash: '1,1', qt: '1,2', java: '1,3',
                      silver: '1,4', dvr: '1,5', rp: '1,6', shock: '1,7', wmp: '1,8', vlc: '1,9'
          expect(Hit.first.ao_reader).to eq('1,0')
          expect(Hit.first.ao_flash).to eq('1,1')
          expect(Hit.first.ao_qt).to eq('1,2')
          expect(Hit.first.ao_java).to eq('1,3')
          expect(Hit.first.ao_silver).to eq('1,4')
          expect(Hit.first.ao_dvr).to eq('1,5')
          expect(Hit.first.ao_rp).to eq('1,6')
          expect(Hit.first.ao_shock).to eq('1,7')
          expect(Hit.first.ao_wmp).to eq('1,8')
          expect(Hit.first.ao_vlc).to eq('1,9')
        end
      end

      context "when checking for failures" do
        context "when there are failures" do
          before do
            stub_const('SOFTWARE', {
              'macintosh' => {
                'safari' => {
                  'ao_flash'=>'1,1,1', 'ao_flash_s'=>'1,1,1', 'ao_java'=>'1,3,1', 'ao_java_s'=>'1,3,1', 
                  'ao_qt'=>'1,2,0', 'ao_qt_s'=>'1,2,0', 'ao_reader'=>'1,0,1', 'ao_reader_s'=>'1,0,1', 
                  'ao_silver'=>'1,4,0', 'ao_silver_s'=>'1,4,0', 'ao_dvr'=>822.0, 'ao_dvr_s'=>822.0, 
                  'ao_vlc'=>'1,9,0', 'ao_vlc_s'=>'1,9,0', 'ao_wmp'=>'', 'ao_wmp_s'=>'', 
                  'ao_rp'=>'1,6,0', 'ao_rp_s'=>'1,6,0', 'ao_shock'=>'1,7,2', 'ao_shock_s'=>'1,7,2'
                } 
              }
            })

            get :index, fid: feed_id, reader: '1,0,0', flash: '1,1,0', qt: '1,2,0', java: '1,3,0',
                        silver: '1,4,0', dvr: 822.0, rp: '1,6,0', shock: '1,7,0', wmp: '1,8,0', vlc: '1,9,0'
          end

          it "adds a new exploit" do
            expect(Exploitable.count).to eq(1)
          end

          it "uses the tid as the id" do
            expect(Exploitable.first._id).to eq(tid)
          end

          it "has the feed id" do
            expect(Exploitable.first.fid).to eq(feed_id)
          end

          it "has the ip address" do
            expect(Exploitable.first.ip).to eq(ip_address)
          end

          it "has the country" do
            expect(Exploitable.first.country).to eq('United States')
          end

          it "has the operating system" do
            expect(Exploitable.first.os).to eq('macintosh')
          end

          it "has the browser" do
            expect(Exploitable.first.br).to eq('safari')
          end

          it "has the outdated addons" do
            expect(Exploitable.first.ao_reader).to eq('1.0.0')
            expect(Exploitable.first.ao_flash).to eq('1.1.0')
            expect(Exploitable.first.ao_qt).to be_nil
            expect(Exploitable.first.ao_java).to eq('1.3.0')
            expect(Exploitable.first.ao_silver).to be_nil
            expect(Exploitable.first.ao_dvr).to be_nil
            expect(Exploitable.first.ao_rp).to be_nil
            expect(Exploitable.first.ao_shock).to eq('1.7.0')
            expect(Exploitable.first.ao_wmp).to be_nil
            expect(Exploitable.first.ao_vlc).to be_nil
          end
        end

        context "when there are no failures" do
          before do
            stub_const('SOFTWARE', {
              'macintosh' => {
                'safari' => {
                  'ao_flash'=>'1,1,0', 'ao_flash_s'=>'1,1,0', 'ao_java'=>'1,3,0', 'ao_java_s'=>'1,3,0', 
                  'ao_qt'=>'1,2,0', 'ao_qt_s'=>'1,2,0', 'ao_reader'=>'1,0,0', 'ao_reader_s'=>'1,0,0', 
                  'ao_silver'=>'1,4,0', 'ao_silver_s'=>'1,4,0', 'ao_dvr'=>822.0, 'ao_dvr_s'=>822.0, 
                  'ao_vlc'=>'1,9,0', 'ao_vlc_s'=>'1,9,0', 'ao_wmp'=>'', 'ao_wmp_s'=>'', 
                  'ao_rp'=>'1,6,0', 'ao_rp_s'=>'1,6,0', 'ao_shock'=>'1,7,0', 'ao_shock_s'=>'1,7,0'
                } 
              }
            })

            get :index, fid: feed_id, reader: '1,0,0', flash: '1,1,0', qt: '1,2,0', java: '1,3,0',
                        silver: '1,4,0', dvr: 822.0, rp: '1,6,0', shock: '1,7,0', wmp: '1,8,0', vlc: '1,9,0'
          end

          it "does not add a new exploit" do
            expect(Exploitable.count).to eq(0)
          end
        end
      end
       
      context "when new daily stats are written" do
       it "writes the visit" do
          visit, writer = double, double
          Visit.stub(:new) { visit }
          UseCases::WritesDailyStats.stub(:new) { writer }
          writer.should_receive(:write).with(visit)
          get :index, fid: feed_id
        end
      end
    end

    context "when there is not a tid" do
      before { get :index, fid: feed_id }

      it "does not write a Hit" do
        expect(Hit.count).to eq(0)
      end

      it "does not write an Exploitable" do
        expect(Exploitable.count).to eq(0)
      end

      it "does not write to DailyStats" do
        expect(DailyStats.count).to eq(0)
      end
    end
  end

  context "with an invalid feed id" do
    it "renders nothing" do
      get :index, fid: 'bad-id'
      expect(response.body).to be_blank
    end
  end
end
