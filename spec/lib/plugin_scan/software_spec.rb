require 'plugin_scan/software'
require 'use_cases/finds_vulnerabilities'
require 'use_cases/finds_exploits'

module PluginScan 
  describe Software do
    let(:software_specs) { double }

    describe ".find_cve_vulns" do
      context "when software is updateable" do
        let(:vulns) { double }
        before { UseCases::FindsVulnerabilities.stub(:find_for).with(software_specs) { vulns } } 

        it "returns vunerabilities when status is 'Update'" do
          expect(Software.find_vulns('Update', software_specs)).to eq(vulns)
        end

        it "returns vunerabilities when status is 'Exploitable'" do
          expect(Software.find_vulns('Exploitable', software_specs)).to eq(vulns)
        end
      end

      context "when software is up to date" do
        it "returns no vulnerabilities" do
          expect(Software.find_vulns('Up To Date', software_specs)).to be_empty
        end
      end
    end

    describe ".find_exploits" do
      context "when software is updateable" do
        let(:exploits) { double }
        before { UseCases::FindsExploits.stub(:find_for).with(software_specs) { exploits } }

        it "returns exploits when status is 'Update'" do
          expect(Software.find_exploits('Update', software_specs)).to eq(exploits)
        end

        it "returns exploits when status is 'Exploitable'" do
          expect(Software.find_exploits('Exploitable', software_specs)).to eq(exploits)
        end
      end

      context "when software is up to date" do
        it "returns no exploits" do
          expect(Software.find_exploits('Up To Date', software_specs)).to be_empty
        end
      end
    end
  end
end
