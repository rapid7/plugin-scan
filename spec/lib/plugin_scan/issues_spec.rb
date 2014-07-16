require 'spec_helper'

module PluginScan
  describe Issues do
    let(:audit) do
      {
        'Adobe Flash' => {
          :detected=>"11,5,0,0", :current=>"11,6,0,0", :security=>"11,5,502,136", :status=>"Update",
          :cve_vulns => [double, double], :exploits => { metasploit: [double], exploit_db: [] }
        },
        'Apple Quicktime' => {
          :detected=>"7,7,1,0", :current=>"7,7,1", :security=>"7,7,1,0", :status=>"Inconclusive",
          :cve_vulns => [double], :exploits => { metasploit: [double], exploit_db: [double, double] }
        }
      }
    end
    subject { Issues.new(audit, nil, nil, nil) }

    describe "#outdated_versions" do
      it "returns outdated software" do
        expect(subject.outdated_versions).to eq({ ao_flash: '11.5.0.0' })
      end
    end

    describe "#number_of_outdated_versions" do
      it "returns the count of outdated software" do
        expect(subject.number_of_outdated_versions).to eq(1)
      end
    end

    describe "#number_of_vulnerabilities" do
      it "returns the count of audited vulnerabilites" do
        expect(subject.number_of_vulnerabilities).to eq(3)
      end
    end

    describe "#number_of_exploits" do
      it "returns the count of audited exploits" do
        expect(subject.number_of_exploits).to eq(4)
      end
    end
  end
end
