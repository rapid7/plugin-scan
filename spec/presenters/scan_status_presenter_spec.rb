require File.expand_path(File.dirname(__FILE__) + '/../../app/presenters/scan_status_presenter')

describe ScanStatusPresenter do
  let(:client) { double('client') }
  let(:issues) { double('issues') }

  before do
    stub_const('PluginScan::VulnerabilityChecker', Class.new)
    client.stub(:issues) { issues } 
  end

  subject { ScanStatusPresenter.new(client) }

  describe "#vulnerable?" do
    it "checks if the issues are vulnerable" do
      PluginScan::VulnerabilityChecker.stub(:is_vulnerable?).with(issues) { true }
      expect(subject.vulnerable?).to be_true
    end
  end

  describe "#number_of_outdated_versions" do
    it "returns the count of outdated versions" do
      issues.stub(:number_of_outdated_versions) { 5 }
      expect(subject.number_of_outdated_versions).to eq(5)
    end
  end

  describe "#audited_software" do
    let(:results) { double('results') }
    before do
      stub_const('SoftwareAuditPresenter', Class.new)
      client.stub(:audit) { Hash['software' => results] } 
    end

    it "wraps each software audit in a presenter" do
      presenter = double
      SoftwareAuditPresenter.stub(:for)
                            .with(OpenStruct.new(name: 'software', audit: results))
                            .and_return(presenter)
      expect{|b| subject.audited_software(&b) }.to yield_successive_args(presenter)
    end
  end

  describe "#number_of_vulnerabilities" do
    it "returns the count of vulnerabilities" do
      issues.stub(:number_of_vulnerabilities) { 2 }
      expect(subject.number_of_vulnerabilities).to eq(2)
    end
  end

  describe "#number_of_exploits" do
    it "returns the count of exploits" do
      issues.stub(:number_of_exploits) { 4 }
      expect(subject.number_of_exploits).to eq(4)
    end
  end

  describe "#outdated?" do
    context "with outdated versions" do
      before { subject.stub(:number_of_outdated_versions) { 1 } }

      it "returns true" do
        expect(subject.outdated?).to be_true
      end
    end

    context "with no outdated versions" do
      before { subject.stub(:number_of_outdated_versions) { 0 } }

      it "returns false" do
        expect(subject.outdated?).to be_false
      end
    end
  end
end
