require File.expand_path(File.dirname(__FILE__) + "/../../app/helpers/chart_helper")

describe ChartHelper do
  include ChartHelper

  describe "#traffic_chart_for" do
    let(:traffic) { double(:traffic) }
    let(:presenter) { double(:presenter) }

    before { stub_const('TrafficChartPresenter', Class.new) }

    it "creates and yields a TrafficChartPresenter" do
      @traffic = traffic
      TrafficChartPresenter.should_receive(:new).with(traffic) { presenter }
      traffic_chart_for do |chart|
        expect(chart).to eq(presenter)
      end    
    end
  end
end
