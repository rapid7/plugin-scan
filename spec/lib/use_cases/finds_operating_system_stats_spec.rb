require 'use_cases/finds_operating_system_stats'

module UseCases
  describe FindsOperatingSystemStats do
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

      context "with stats for two browsers" do
        before do
          two_oses = double()
          one_os   = double()

          two_oses.stub(:get_values_for).with(:oses).and_return([
            {'os'=>'windows','count'=>2}, {'os'=>'linux','count'=>4}
          ])
          one_os.stub(:get_values_for).with(:oses).and_return([
            {'os'=>'windows','count'=>3}
          ])

          stats << two_oses
          stats << one_os
        end

        it "returns 2 sets of counts" do
          expect(subject.find_stats(feed, duration).size).to eq(2)
        end

        it "returns the count for windows first" do
          first = subject.find_stats(feed, duration)[0]
          expect(first.value).to eq('windows')
          expect(first.count).to eq(5)
        end

        it "returns the count for linux second" do
          second = subject.find_stats(feed, duration)[1]
          expect(second.value).to eq('linux')
          expect(second.count).to eq(4) 
        end
      end
    end
  end
end
