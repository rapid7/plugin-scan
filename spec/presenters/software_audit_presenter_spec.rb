require File.expand_path(File.dirname(__FILE__) + '/../../app/presenters/software_audit_presenter')

describe SoftwareAuditPresenter do
  let(:name) { 'java' }
  let(:audit) { Hash[detected: '1,0,0', current: '1,0,1'] }
  let(:software) { double(name: name, audit: audit) }
  let(:websites) { double }
  let(:image) { double }

  before do
    stub_const("PluginScan::Websites", websites)
    stub_const("PluginScan::Images", image)
  end

  subject { SoftwareAuditPresenter.for(software) }

  describe "#image_tag" do
    it "returns an image tag based on the name" do
      image.stub(:render).with(name, 32) { 'image_tag' }
      expect(subject.image_tag).to eq('image_tag')
    end
  end

  describe "#version" do
    it "returns a dotted version number" do
      expect(subject.version).to eq('1.0.0')
    end
  end

  describe "#current_version" do
    it "returns a dotted version number" do
      expect(subject.current_version).to eq('1.0.1')
    end
  end

  describe "#update_available?" do
    it "updateable if it is exploitable" do
      audit[:status] = 'Exploitable'
      expect(subject.update_available?).to be_true
    end

    it "updateable if it has an update" do
      audit[:status] = 'Update'
      expect(subject.update_available?).to be_true
    end
  end

  describe "#download_url" do
    it "returns a url based on the name" do
      url = 'http://example.com/download'
      websites.stub(:link).with(name) { url }
      expect(subject.download_url).to eq(url)
    end
  end

  describe "#vulnerable?" do
    it "vulnerable with cves" do
      subject.stub(:cve_urls) { [double] }
      expect(subject.vulnerable?).to be_true
    end
  end

  describe "#cve_urls" do
    it "returns a url for each cve" do
      audit[:cve_vulns] = [double(id: 'CVE/2013-0000', summary: 'a summary')]
      expect(subject.cve_urls).to eq([
        "<a href='http://cvedetails.com/cve/CVE-2013-0000'>[CVE-2013-0000] a summary</a>"
      ])
    end

    context "when summary is greater than 60 characters" do
      it "returns a url for each cve" do
        audit[:cve_vulns] = [double(id: 'CVE/2013-0000', 
                                    summary: 'Multiple stack-based buffer overflows in Apple QuickTime before 7.7.2')]
        expect(subject.cve_urls).to eq([
          "<a href='http://cvedetails.com/cve/CVE-2013-0000'>[CVE-2013-0000] Multiple stack-based buffer overflows in Apple ...</a>"
        ])
      end
    end
  end

  describe "#exploitable?" do
    context "with metasploit urls" do
      it "returns true" do
        subject.stub(:metasploit_urls => [double],
                     :exploit_db_urls => []) 
        expect(subject.exploitable?).to be_true
      end
    end

    context "with exploit db urls" do
      it "returns true" do
        subject.stub(:metasploit_urls => [],
                     :exploit_db_urls => [double]) 
        expect(subject.exploitable?).to be_true
      end
    end
  end

  describe "#metasploit_urls" do
    it "returns a url for each exploit" do
      exploit = double(title: 'a title', fullname: 'some/exploit')
      audit[:exploits] = Hash[metasploit: [exploit]]
      expect(subject.metasploit_urls).to eq([
        "<a href='http://www.metasploit.com/modules/some/exploit'>a title</a>"
      ])
    end

    it "returns an empty array with no exploits" do
      audit[:exploits] = {}
      expect(subject.metasploit_urls).to be_empty
    end
  end

  describe "#exploit_db_urls" do
    it "returns a url for each exploit" do
      exploit = double(title: 'a title', id: '12345')
      audit[:exploits] = Hash[exploit_db: [exploit]]
      expect(subject.exploit_db_urls).to eq([
        "<a href='http://www.exploit-db.com/exploits/12345/'>a title</a>"
      ])
    end

    it "returns an empty array with no exploits" do
      audit[:exploits] = {}
      expect(subject.exploit_db_urls).to be_empty
    end
  end

  describe "#show_exploits_and_vulns" do
    context "with exploits" do
      before { subject.stub(:exploitable? => true, :vulnerable? => false) }

      it "returns true" do
        expect(subject.show_exploits_and_vulns?).to be_true
      end
    end

    context "with vulns" do
      before { subject.stub(:exploitable? => false, :vulnerable? => true) }

      it "returns true" do
        expect(subject.show_exploits_and_vulns?).to be_true
      end
    end

    context "with no exploits and no vulns" do
      before { subject.stub(:exploitable? => false, :vulnerable? => false) }

      it "returns false" do
        expect(subject.show_exploits_and_vulns?).to be_false
      end
    end
  end
end
