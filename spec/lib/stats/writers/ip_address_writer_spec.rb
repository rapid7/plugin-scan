require 'spec_helper'

module Stats::Writers
  describe IpAddressWriter do
    describe "#write" do
      let(:document) { DailyStats.create }
      let(:visit) do
        double('visit', hit: Hash[:ip => '127.0.0.1'], has_hit?: true) 
      end

      it "implements the write interface" do
        expect(subject.respond_to?(:write)).to be_true
      end

      context "with a new ip address" do
        it "adds the ip address" do
          subject.write(document, visit)
          expect(DailyStats.first.ip_addresses.first).to include({ 'ip' => '127.0.0.1' })
        end

        it "adds an initial total count of 1" do
          subject.write(document, visit)
          expect(DailyStats.first.ip_addresses.first).to include({ 'count' => 1 })
        end
      end

      context "with an existing ip address" do
        before do
          document.add_to_set(:ip_addresses, {'ip' => '127.0.0.1', 'count' => 4})
        end

        it "adds 1 to the existing ip address count" do
          subject.write(document, visit)
          expect(DailyStats.first.ip_addresses.first).to include({ 'count' => 5 })
        end
      end

      context "with no hit" do
        before { visit.stub(has_hit?: false) }

        it "does nothing" do
          subject.write(document, visit)
          expect(document.has_attribute?(:ip_addresses)).to be_false
        end 
      end
    end
  end
end
