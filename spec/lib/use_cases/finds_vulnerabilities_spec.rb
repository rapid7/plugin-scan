require 'use_cases/finds_vulnerabilities'

module UseCases
  describe FindsVulnerabilities do
    let(:software) { 'test-name' }
    let(:version)  { 'test-version' }
    let(:db) { double }

    before { stub_const('VulnDb', Class.new) }
    subject { FindsVulnerabilities.new(software, version) }

    describe "#find_cves" do
      it "looks for cves using the VulnDb" do
        VulnDb.stub(:for).with(software, version) { db }
        cve_id = 'CVE/2013-0000'
        db.stub(:cves) { [cve_id] }
        expect(subject.find_cves).to eq([cve_id])
      end
    end
  end
end
