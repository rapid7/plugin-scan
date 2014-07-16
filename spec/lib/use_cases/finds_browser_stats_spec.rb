require 'use_cases/finds_browser_stats'

module UseCases
  describe FindsBrowserStats do
    let(:feed) { '12345' }
    let(:duration) { double('duration') }
    let(:stats) { Array.new }
  
    before do
      stub_const("Repositories::DailyStatsRepository", Class.new)
      Repositories::DailyStatsRepository.stub(:find_by_feed_and_duration)
                                        .with(feed, duration)
                                        .and_return(stats)
    end

    describe "#find_stats" do
      context "with no stats" do
        it "should return no stats" do
          expect(subject.find_stats(feed, duration)).to be_empty
        end
      end

      context "with stats for safari and chrome" do
        before do
          two_browsers = double()
          one_browser  = double()

          two_browsers.stub(:get_values_for).with(:browsers).and_return([
            {'browser'=>'safari','count'=>2}, {'browser'=>'chrome','count'=>4}
          ]) 
          one_browser.stub(:get_values_for).with(:browsers).and_return([
            {'browser'=>'safari','count'=>3}
          ])

          stats << two_browsers
          stats << one_browser
        end

        it "returns counts for safari and chrome" do
          expect(subject.find_stats(feed, duration).size).to eq(2)
        end

        it "returns the count for safari first" do
          first = subject.find_stats(feed, duration)[0]
          expect(first.value).to eq('safari')
          expect(first.count).to eq(5)
        end

        it "returns the count for chrome second" do
          second = subject.find_stats(feed, duration)[1]
          expect(second.value).to eq('chrome')
          expect(second.count).to eq(4) 
        end
      end
    end
  end
end
