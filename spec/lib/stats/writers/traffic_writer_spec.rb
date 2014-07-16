require 'spec_helper'

module Stats::Writers
  describe TrafficWriter do
    describe "#write" do
      let(:document) { DailyStats.create }
      let(:visit) do
        double('visit', 
               has_hit?: true,
               hit: Hash[:br => 'firefox'], 
               has_failures?: true) 
      end

      it "implements the write interface" do
        expect(subject.respond_to?(:write)).to be_true
      end

      context "with new traffic" do
        it "adds an initial total count of 1" do
          subject.write(document, visit)
          expect(DailyStats.first.traffic).to include({ 'total' => 1 })
        end

        it "adds an initial outdated count of 1" do
          subject.write(document, visit)
          expect(DailyStats.first.traffic).to include({ 'outdated' => 1 })
        end
      end

      context "with existing traffic" do
        before do
          document.set(:traffic, {'total' => 4, 'outdated' => 2})
        end

        it "adds 1 to the existing total count" do
          subject.write(document, visit)
          expect(DailyStats.first.traffic).to include({ 'total' => 5 })
        end

        it "adds 1 to the existing outdated count" do
          subject.write(document, visit)
          expect(DailyStats.first.traffic).to include({ 'outdated' => 3 })
        end
      end

      context "without a hit" do
        before { visit.stub(:has_hit? => false) }

        it "does not add a total count" do
          subject.write(document, visit)
          expect(DailyStats.first.traffic.keys).to_not include('total')
        end
      end

      context "without failures" do
        before { visit.stub(:has_failures? => false) }

        it "does not add an outdated count" do
          subject.write(document, visit)
          expect(DailyStats.first.traffic.keys).to_not include('outdated')
        end
      end

    end
  end
end
