require 'use_cases/writes_daily_stats'

module UseCases
  describe WritesDailyStats do
    before { stub_const("DailyStats", Class.new) }

    let(:writer) { double(:writer).as_null_object }
    let(:factory) { double(:factory) }
    let(:visit) { double('visit', date: date, feed_id: '12345') }
    let(:date) { double('date') }

    subject { WritesDailyStats.new(factory) }

    describe "#write" do
      let(:document) { double(:document) }

      before do
        DailyStats.stub(:find_or_create_by => document) 
        factory.stub(:all_writers => [writer])
      end

      it "finds or creates a new stat for the feed and date" do
        DailyStats.should_receive(:find_or_create_by).with(fid: '12345', date: date)
        subject.write(visit)
      end

      it "should write the stats" do
        writer.should_receive(:write).with(document, visit)
        subject.write(visit)
      end 
    end
  end
end

