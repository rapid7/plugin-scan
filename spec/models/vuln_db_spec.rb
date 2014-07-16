require 'spec_helper'

describe VulnDb do
  let(:quicktime) { 'Apple Quicktime' }
  let(:real_player) { 'RealPlayer' }
  before { stub_const('VULN_DB_SOURCE', 'spec/fixtures/vdb.json') }

  describe "#cves" do
    context "when quicktime matches are found" do
      context "with different version formats" do
        it "knows to pad one zero" do
          id = VulnDb.for(real_player, '8.0.0.0').cves.first.id
          expect(id).to eq('CVE/2013-0002')
        end

        it "knows to pad two zeros" do
          id = VulnDb.for(quicktime, '7.7.1.0').cves.first.id
          expect(id).to eq('CVE/2013-0004')
        end
      end

      it "returns the cve ids" do
        ids = VulnDb.for(quicktime, '7.3.0.0').cves.collect(&:id)
        expect(ids).to eq(['CVE/2013-0004', 'CVE/2013-0003', 'CVE/2013-0001'])
      end

      it "returns the cve summaries" do
        summaries = VulnDb.for(quicktime, '7.3.0.0').cves.collect(&:summary)
        expect(summaries).to eq(['Quicktime 004', 'Quicktime 003', 'Quicktime 001'])
      end
    end

    context "when quicktime matches are not found" do 
      it "returns an empty array" do
        expect(VulnDb.for(real_player, '1.0').cves).to be_empty
      end
    end
  end

  describe "#exploits" do
    context "for metasploit" do
      context "when there are exploits" do
        subject { VulnDb.for(quicktime, '7.7.1.0') }

        it "returns the exploit titles" do
          exploit = subject.exploits[:metasploit].first
          expect(exploit.title).to eq("Apple Quicktime Exploit")
        end

        it "returns the exploit fullnames" do
          exploit = subject.exploits[:metasploit].first
          expect(exploit.fullname).to eq("exploit/apple/quicktime")
        end
      end

      context "when there are no exploits" do
        it "returns an empty array" do
          expect(VulnDb.for(real_player, '7.0').exploits[:metasploit]).to be_empty
        end
      end
    end

    context "for exploit db" do
      context "when there are exploits" do
        subject { VulnDb.for(quicktime, '7.7.1.0') }

        it "returns the exploit titles" do
          exploit = subject.exploits[:exploit_db].first
          expect(exploit.title).to eq("Exploit DB Test Exploit")
        end

        it "returns the exploit ids" do
          exploit = subject.exploits[:exploit_db].first
          expect(exploit.id).to eq("12345")
        end
      end

      context "when there are no exploits" do
        it "returns an empty array" do
          expect(VulnDb.for(real_player, '7.0').exploits[:exploit_db]).to be_empty
        end
      end
    end
  end
end
