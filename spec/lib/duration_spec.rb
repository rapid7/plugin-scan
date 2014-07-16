require 'timecop'
require 'active_support/all'
require File.expand_path(File.dirname(__FILE__) + "/../../lib/duration")

describe Duration do
  before { Timecop.freeze(Time.utc(2013, 03, 21, 13, 0, 0)) }
  after { Timecop.return }

  let(:start_time) { 1.day.ago }
  let(:end_time) { 1.day.from_now }

  context "with a time range" do
    subject { Duration.between(start_time, end_time) }

    it "assigns the start time" do
      expect(subject.start_time).to eq(start_time)
    end

    it "assigns the end time" do
      expect(subject.end_time).to eq(end_time)
    end

    it "calculate the number of days" do
      expect(subject.days).to eq(2)
    end
  end

  context "with a specified number of prior days" do
    subject { Duration.for_days_prior(30) }

    it "calculates a start time in the past beginning at midnight" do
      expect(subject.start_time.to_i).to eq(Time.utc(2013, 02, 19, 13, 0, 0).to_i)
    end

    it "calculates an end time for today just before midnight" do
      expect(subject.end_time.to_i).to eq(Time.utc(2013, 03, 21, 13, 0, 0).to_i)
    end

    it "assigns the number of days" do
      expect(subject.days).to eq(30)
    end
  end

  context "with a time range in seconds" do
    subject { Duration.between_seconds(start_time.to_i, end_time.to_i) }

    it "creates the start time" do
      expect(subject.start_time).to eq(start_time)
    end

    it "creates the end time" do
      expect(subject.end_time).to eq(end_time)
    end
  end

  describe "#as_dates" do
    subject { Duration.between(start_time, end_time) }

    it "returns the time range as a collection of dates" do
      expect(subject.as_dates).to eq([
        '2013-03-20'.to_date,
        '2013-03-21'.to_date,
        '2013-03-22'.to_date
      ])
    end
  end
end
