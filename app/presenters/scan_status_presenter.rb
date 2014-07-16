require 'ostruct'

class ScanStatusPresenter
  attr_reader :client

  def initialize(client)
    @client = client
  end

  def vulnerable?
    PluginScan::VulnerabilityChecker.is_vulnerable?(client.issues)
  end

  def outdated?
    number_of_outdated_versions > 0
  end

  def number_of_outdated_versions
    client.issues.number_of_outdated_versions
  end

  def number_of_vulnerabilities
    client.issues.number_of_vulnerabilities
  end

  def number_of_exploits
    client.issues.number_of_exploits
  end

  def audited_software(&block)
    [].tap do |results|
      client.audit.each do |key, value| 
        software = OpenStruct.new(name: key, audit: value)
        results << SoftwareAuditPresenter.for(software)
      end
    end.each(&block)
  end
end
