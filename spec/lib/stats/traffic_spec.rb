require 'active_support/all'
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/stats/traffic')

module Stats
  describe Traffic do
    context "with no data" do
      subject { Traffic.new }

      it "returns today for date" do
        expect(subject.date).to eq(Time.now.utc.to_date)
      end

      it "returns 0 for hit count" do
        expect(subject.hit).to eq(0)
      end

      it "returns 0 for outdated count" do
        expect(subject.outdated).to eq(0)
      end
    end

    context "with data" do
      let(:date) { Time.now.utc.to_date }
      subject do
        Traffic.new(date: date,
                    hit: 5,
                    outdated: 3)
      end

      it "returns the date" do
        expect(subject.date).to eq(date)
      end

      it "returns the hit count" do
        expect(subject.hit).to eq(5)
      end

      it "returns the outdated count" do
        expect(subject.outdated).to eq(3)
      end
    end
  end
end
