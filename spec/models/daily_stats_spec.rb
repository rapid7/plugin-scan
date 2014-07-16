require 'spec_helper'

describe DailyStats do
  describe "#get_values_for" do
    context "with an invalid attribute" do
      it "returns an empty array" do
        expect(subject.get_values_for(:foo)).to be_empty
        expect(subject.get_values_for('foo')).to be_empty
      end
    end
    
    context "with a valid attribute" do
      let(:values) { [1,2,3] }

      before { subject.write_attribute(:foo, values) }

      it "returns the values for the attribute" do
        expect(subject.get_values_for(:foo)).to eq(values) 
        expect(subject.get_values_for('foo')).to eq(values)
      end

      context "with a single value" do
        before { subject.write_attribute(:bar, 42) }

        it "returns the value in an array" do
          expect(subject.get_values_for(:bar)).to eq([42]) 
          expect(subject.get_values_for('bar')).to eq([42])
        end
      end
    end
  end

  describe "#create_traffic" do
    let(:today) { Time.now.utc }
    subject { DailyStats.new(date: today) }

    context "with traffic" do
      before { subject.write_attribute(:traffic, {'total' => 10, 'outdated' => 5}) }

      it "includes the date" do
        expect(subject.create_traffic.date).to eq(today.to_date)
      end

      it "includes the total traffic count" do
        expect(subject.create_traffic.hit).to eq(10)
      end

      it "includes the outdated traffic count" do
        expect(subject.create_traffic.outdated).to eq(5)
      end
    end

    context "with no traffic" do
      it "total count should be zero" do
        expect(subject.create_traffic.hit).to eq(0)
      end

      it "outdated count should be zero" do
        expect(subject.create_traffic.outdated).to eq(0)
      end
    end
  end
end
