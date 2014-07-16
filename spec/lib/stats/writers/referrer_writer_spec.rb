require 'spec_helper'

module Stats::Writers
  describe ReferrerWriter do
    describe "#write" do
      let(:document) { DailyStats.create }
      let(:visit) do
        double('visit', hit: Hash[:rf => 'host'], has_hit?: true) 
      end

      it "implements the write interface" do
        expect(subject.respond_to?(:write)).to be_true
      end

      context "with a new host" do
        it "adds the how" do
          subject.write(document, visit)
          expect(DailyStats.first.referrers.first).to include({ 'host' => 'host' })
        end

        it "adds an initial total count of 1" do
          subject.write(document, visit)
          expect(DailyStats.first.referrers.first).to include({ 'count' => 1 })
        end
      end

      context "with an existing host" do
        before do
          document.add_to_set(:referrers, {'host' => 'host', 'count' => 4})
        end

        it "adds 1 to the existing host count" do
          subject.write(document, visit)
          expect(DailyStats.first.referrers.first).to include({ 'count' => 5 })
        end
      end

      context "with no hit" do
        before { visit.stub(has_hit?: false) }

        it "does nothing" do
          subject.write(document, visit)
          expect(document.has_attribute?(:referrers)).to be_false
        end
      end
    end
  end
end
