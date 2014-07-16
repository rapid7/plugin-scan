require 'spec_helper'

module Stats::Writers
  describe OperatingSystemWriter do
    describe "#write" do
      let(:document) { DailyStats.create }
      let(:visit) { double('visit', hit: Hash[:os => 'windows'], has_hit?: true) }

      it "implements the write interface" do
        expect(subject.respond_to?(:write)).to be_true
      end

      context "with no os" do
        it "adds the os with a count of 1" do
          subject.write(document, visit)
          expect(DailyStats.first.oses).to eq([
            { 'os' => 'windows', 'count' => 1 }
          ])
        end
      end

      context "with existing os" do
        before do
          document.add_to_set(:oses, {'os' => 'windows', 'count' => 4})
        end

        it "adds 1 to the existing count" do
          subject.write(document, visit)
          expect(DailyStats.first.oses).to eq([
            { 'os' => 'windows', 'count' => 5 }
          ])
        end
      end

      context "with no hit" do
        before { visit.stub(has_hit?: false) }

        it "does nothing" do
          subject.write(document, visit)
          expect(document.has_attribute?(:oses)).to be_false
        end
      end
    end
  end
end
