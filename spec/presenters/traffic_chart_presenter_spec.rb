require 'active_support/all'
require File.expand_path(File.dirname(__FILE__) + '/../../app/presenters/traffic_chart_presenter')

describe TrafficChartPresenter do
  let(:traffic) { double(:traffic) }
  subject { TrafficChartPresenter.new(traffic) }

  describe "#dates" do
   it "returns the dates as a comma-separated list" do
      traffic.stub(:dates => [
        double(:month => 1, :day => 10),
        double(:month => 1, :day => 11),
        double(:month => 1, :day => 12)
      ])
      expect(subject.dates).to eq("'1/10', '1/11', '1/12'")
    end
  end

  describe "#hits" do
    it "returns the hit counts as a comma-separated list" do
      traffic.stub(:hits_per_date => [3, 2, 1])
      expect(subject.hits).to eq('3, 2, 1')
    end
  end

  describe "#outdated" do
    it "returns the outdated counts as a comma-separated list" do
      traffic.stub(:outdated_per_date => [0, 1, 2])
      expect(subject.outdated).to eq('0, 1, 2')
    end
  end

  describe "#tick_interval" do
    it "return 3 with thirty or more dates" do
      traffic.stub_chain(:dates, :length => 30)
      expect(subject.tick_interval).to eq(3)
    end

    it "return 1 with less than thirty dates" do
      traffic.stub_chain(:dates, :length => 29)
      expect(subject.tick_interval).to eq(1)
    end
  end
end
