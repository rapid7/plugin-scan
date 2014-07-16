require 'spec_helper'

describe Visit do
  describe "::for_hit" do
    let(:yesterday) { 1.day.ago.to_date }
    subject do
      Visit.for_hit(double(created_at: yesterday, to_hash: {foo: 'bar'}))
    end

    it "uses the date of the hit object" do
      expect(subject.date).to eq(yesterday) 
    end

    it "has a hit" do
      expect(subject.has_hit?).to be_true
    end

    it "stores the results of to_hash as the hit" do
      expect(subject.hit).to eq({foo: 'bar'})
    end

    it "has no failures" do
      expect(subject.has_failures?).to be_false
    end
  end

  describe "::for_failures" do
    let(:two_days_ago) { 2.days.ago.to_date }
    subject do
      Visit.for_failures(double(created_at: two_days_ago, to_hash: {bar: 'baz'})) 
    end

    it "uses the date of the exploitable object" do
      expect(subject.date).to eq(two_days_ago)
    end

    it "has failures" do
      expect(subject.has_failures?).to be_true
    end

    it "stores the results of to_hash as the failures" do
      expect(subject.failures).to eq({bar: 'baz'})
    end

    it "has no hit" do
      expect(subject.has_hit?).to be_false
    end
  end

  context "with an empty visit" do
    let(:date) { Time.now.utc.to_date }

    subject { Visit.new(date: date) }

    it "has today's date" do
      expect(subject.date).to eq(date)
    end

    it "has no hit" do
      expect(subject.has_hit?).to be_false
    end

    it "has no failures" do
      expect(subject.has_failures?).to be_false
    end
  end  

  context "with a hit" do
    subject { Visit.new(hit: Hash[fid: '12345']) }

    it "has a hit" do
      expect(subject.has_hit?).to be_true
    end

    it "returns the feed id" do
      expect(subject.feed_id).to eq('12345')
    end
  end  

  context "with failures" do
    subject { Visit.new(failures: Hash[fid: '22222', 'foo' => 'bar']) }

    it "has failures" do
      expect(subject.has_failures?).to be_true
    end

    it "returns the feed id" do
      expect(subject.feed_id).to eq('22222')
    end
  end
end
