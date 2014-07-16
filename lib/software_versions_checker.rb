class SoftwareVersionsChecker
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def check(info)
    outdated_versions = check_for_outdated_versions(info)
    SoftwareVersionsReport.new(info, outdated_versions)
  end

  def check_for_outdated_versions(info)
    {}.tap do |outdated|
      client = PluginScan::Client.new(source.user_agent,
                                      source.params,
                                      source.remote_ip,
                                      source.request)
      client.issues.outdated_versions.each do |key, value|
        outdated[key] = value
      end

      unless outdated.empty?
        outdated[:br] = info[:br]
        outdated[:ip] = info[:ip]
        outdated[:os] = info[:os]
        outdated[:fid] = info[:fid]
        outdated[:country] = info[:country]
      end
    end
  end
end

class SoftwareVersionsReport < Struct.new(:hit_versions, :outdated_versions)
end

