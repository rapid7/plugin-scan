require 'spec_helper'

module Stats::Writers
  describe CountryWriter do
    describe "#write" do
      let(:document) { DailyStats.create }
      let(:visit) do
        double('visit', hit: Hash[:country => 'US'], has_failures?: true) 
      end

      it "implements the write interface" do
        expect(subject.respond_to?(:write)).to be_true
      end

      context "with a new country" do
        it "adds the how" do
          subject.write(document, visit)
          expect(DailyStats.first.countries.first).to include({ 'country' => 'US' })
        end

        it "adds an initial outdated count of 1" do
          subject.write(document, visit)
          expect(DailyStats.first.countries.first).to include({ 'outdated_count' => 1 })
        end
      end

      context "with an existing country" do
        before do
          document.add_to_set(:countries, {'country' => 'US', 'outdated_count' => 4})
        end

        it "adds 1 to the existing country count" do
          subject.write(document, visit)
          expect(DailyStats.first.countries.first).to include({ 'outdated_count' => 5 })
        end
      end

      context "with no failures" do
        before { visit.stub(has_failures?: false) }

        it "does nothing" do
          subject.write(document, visit)
          expect(document.has_attribute?(:countries)).to be_false
        end
      end
    end
  end
end
