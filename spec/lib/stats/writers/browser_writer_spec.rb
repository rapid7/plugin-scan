require 'spec_helper'

module Stats::Writers
  describe BrowserWriter do
    describe "#write" do
      let(:document) { DailyStats.create }
      let(:visit) { double('visit', hit: Hash[:br => 'firefox'], has_hit?: true) }

      it "implements the write interface" do
        expect(subject.respond_to?(:write)).to be_true
      end

      context "with a new browser" do
        it "adds the browser with a count of 1" do
          subject.write(document, visit)
          expect(DailyStats.first.browsers).to eq([
            { 'browser' => 'firefox', 'count' => 1 }
          ])
        end
      end

      context "with existing browser" do
        before do
          document.add_to_set(:browsers, {'browser' => 'firefox', 'count' => 4})
        end

        it "adds 1 to the existing count" do
          subject.write(document, visit)
          expect(DailyStats.first.browsers).to eq([
            { 'browser' => 'firefox', 'count' => 5 }
          ])
        end
      end

      context "with no hit" do
        before { visit.stub(has_hit?: false) }

        it "does nothing" do
          subject.write(document, visit)
          expect(document.has_attribute?(:browsers)).to be_false
        end
      end
    end
  end
end
