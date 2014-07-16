require 'spec_helper'

describe DashboardPagePresenter do
  describe "#graph_prefix_uri" do
    let(:feed) { double(:fid => 'feed-id') }
    let(:duration) { double(:start_time => 100, :end_time => 200) }
    before { Duration.stub(:for_days_prior).with(30).and_return(duration) } 

    subject { DashboardPagePresenter.new(feed: feed, days: 30) }

    it "renders the dashboard_graph_uri without the graph" do
      expect(subject.graph_prefix_uri).to eq('/dashboard/graph/feed-id/100/200/')
    end
  end
end
