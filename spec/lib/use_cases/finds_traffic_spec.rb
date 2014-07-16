require 'active_support/all'
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/use_cases/finds_traffic')

module UseCases
  describe FindsTraffic do
    let(:feed) { double(:duration, :fid => 'feed-id') }
    let(:jan1) { Date.new(2013, 1, 1) }
    let(:jan2) { Date.new(2013, 1, 2) }
    let(:jan3) { Date.new(2013, 1, 3) }
    let(:duration) { double(:duration, :as_dates => [jan1, jan2, jan3]) }

    before do 
      stats = [
        double(:create_traffic => double(:date => jan2, :hit => 6, :outdated => 2)),
        double(:create_traffic => double(:date => jan3, :hit => 7, :outdated => 3)),
        double(:create_traffic => double(:date => jan1, :hit => 5, :outdated => 1))
      ]
      stub_const("Repositories::DailyStatsRepository", Class.new)
      Repositories::DailyStatsRepository.stub(:find_by_feed_and_duration)
                                        .with('feed-id', duration) { stats }
    end

    subject { FindsTraffic.find_for(feed, duration) }

    it "has the duration" do
      expect(subject.dates).to eq([jan1, jan2, jan3])
    end

    it "has a collection of hit counts per date" do
      expect(subject.hits_per_date).to eq([5,6,7])
    end

    it "has a collection of outdated counts per date" do
      expect(subject.outdated_per_date).to eq([1,2,3])
    end

    it "prints all of the counts" do
      expect(subject.to_s).to eq("['1/1', 5, 1], ['1/2', 6, 2], ['1/3', 7, 3]")
    end
  end
end
