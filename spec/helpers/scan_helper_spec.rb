require File.expand_path(File.dirname(__FILE__) + '/../../app/helpers/scan_helper')

describe ScanHelper do
  include ScanHelper

  describe "#scan_status_for" do
    let(:client) { double('client') }

    before do
      stub_const('ScanStatusPresenter', Class.new) 
      @client = client
    end

    it "yields an instance of ScanStatusPresenter" do
      presenter = double
      ScanStatusPresenter.stub(:new).with(client) { presenter }
      expect{|b| scan_status_for(&b)}.to yield_successive_args(presenter)
    end
  end
end
