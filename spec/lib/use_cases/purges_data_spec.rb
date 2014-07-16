require 'use_cases/purges_data'

module UseCases
  describe PurgesData do
    before { stub_const("DailyStats", Class.new) }

    describe "#purge_by_feed" do
      let(:feed_id) { 'feed_id' }
      let(:stats) { double(:daily_stats).as_null_object }

      before { DailyStats.stub(:where => stats) }

      it "finds stats for a specific feed" do
        DailyStats.should_receive(:where).with(fid: feed_id)
        subject.purge_by_feed(feed_id)
      end

      it "deletes the stats" do
        stats.should_receive(:delete)
        subject.purge_by_feed(feed_id)
      end
    end
  end
end
