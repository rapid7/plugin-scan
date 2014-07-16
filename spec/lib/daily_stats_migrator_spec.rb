require 'spec_helper'

describe DailyStatsMigrator do
  let(:duration) { double('duration').as_null_object }

  describe '::migrate_for_date_range' do
    let(:migrator) { double('migrator').as_null_object }

    before { DailyStatsMigrator.stub(:new => migrator) }

    it "create a new migrator with the duration" do
      DailyStatsMigrator.should_receive(:new)
                        .with(:duration => duration)
      DailyStatsMigrator.migrate_for_date_range(duration)
    end

    it "calls migrate" do
      migrator.should_receive(:migrate)
      DailyStatsMigrator.migrate_for_date_range(duration)
    end
  end

  describe '#migrate' do
    let(:visit) { double('visit').as_null_object }
    let(:writer) { double('writer').as_null_object }
    let(:start_time) { 1.day.ago }
    let(:end_time) { 1.day.from_now }

    subject do
      DailyStatsMigrator.new({
        :writer => writer, :duration => duration
      })
    end

    before { duration.stub(:start_time => start_time, :end_time => end_time) }

    context "for hits" do
      let(:hit) { double('hit').as_null_object }

      before do
        Hit.stub(:where => [hit]) 
        Visit.stub(:for_hit => visit)
      end

      it "converts each hit to a visit" do
        Visit.should_receive(:for_hit).with(hit)
        subject.migrate
      end

      it "writes each visit" do
        writer.should_receive(:write).with(visit)
        subject.migrate
      end

      it "finds hits for the given time range" do
        Hit.should_receive(:where).with(
          :created_at.gte => start_time, :created_at.lte => end_time
        )
        subject.migrate
      end
    end

    context "for exploitable" do
      let(:exploit) { double('exploit').as_null_object }

      before do
        Exploitable.stub(:where => [exploit]) 
        Visit.stub(:for_failures => visit)
      end

      it "converts each exploit to a visit" do
        Visit.should_receive(:for_failures).with(exploit)
        subject.migrate
      end

      it "writes each visit" do
        writer.should_receive(:write).with(visit)
        subject.migrate
      end

      it "finds exploits before and after a given time range" do
        Exploitable.should_receive(:where).with(
          :created_at.gte => start_time, :created_at.lte => end_time
        )
        subject.migrate
      end
    end
  end
end
