module UseCases
  class FindsVulnerabilities
    attr_reader :software, :version

    def initialize(software, version)
      @software = software
      @version  = version
    end

    def find_cves
      VulnDb.for(software, version).cves
    end

    def self.find_for(software_specs)
      VulnDb.for(software_specs.full_name, software_specs.version).cves
    end
  end
end
