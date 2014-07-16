module PluginScan
  class Issues < Struct.new(:audit, :country, :feed, :ip)
    def to_h
      info = {'Feed' => feed, 'IP Address' => ip, 'Country' => country}
      issues = {}
      count = 0
      audit.keys.each do |software|
        if audit[software][:status] == 'Exploitable'
          issues[software] = audit[software][:detected]
          count += 1
        end
      end

      if issues.empty?
        return nil
      else
        info[:count] = count
        info.merge(issues)
      end
    end

    def up_to_date?
      audit.keys.each do |software|
        return false if ['Update', 'Exploitable'].include? audit[software][:status]
      end
      return true
    end

    def outdated_versions
      converter = Software::NameConverter.new
      outdated_software.inject({}) do |hash, (key,value)|
        hash[converter.as_symbol(key)] = value[:detected].gsub(",",".")
        hash
      end
    end

    def number_of_outdated_versions
      outdated_software.size
    end

    def number_of_vulnerabilities
      audit.inject(0) { |memo, (k, v)| memo += v[:cve_vulns].size } 
    end

    def number_of_exploits
      audit.inject(0) { |memo, (k, v)| memo += v[:exploits].values.flatten.size } 
    end

    def vulnerable
      cnt = 0
      audit.keys.each do |software|
        if ['Exploitable'].include? audit[software][:status]
          cnt += 1
        end
      end
      return cnt
    end

    def to_s
      if to_h
        to_h.map{|k,v| "#{k}: #{v}"}.join('\n')
      else
        return false
      end
    end

    def to_html
      unless to_h.empty?
        to_h.map{|k,v| "#{k}: #{v}"}.join('<br>')
      end
    end

    def to_mongo
      if to_h
        software = to_h
        details = {}
        details[:fid] = feed unless feed.nil?
        details[:country] = country unless country.nil?
        details[:ip] = software['IP Address'] unless software['IP Address'].nil?
        details[:ao_reader] = software['Adobe Reader'] unless software['Adobe Reader'].nil?
        details[:ao_dvr] = software['Phoscode DevalVR'] unless software['Phoscode DevalVR'].nil?
        details[:ao_flash] = software['Adobe Flash'] unless software['Adobe Flash'].nil?
        details[:ao_java] = software['Oracle Java'] unless software['Oracle Java'].nil?
        details[:ao_qt] = software['Apple Quicktime'] unless software['Apple Quicktime'].nil?
        details[:ao_rp] = software['RealPlayer'] unless software['RealPlayer'].nil?
        details[:ao_shock] = software['Adobe Shockwave'] unless software['Adobe Shockwave'].nil?
        details[:ao_silver] = software['Microsoft Silverlight'] unless software['Microsoft Silverlight'].nil?
        details[:ao_wmp] = software['Windows Media Player'] unless software['Windows Media Player'].nil?
        details[:ao_vlc] = software['VLC Media Player'] unless software['VLC Media Player'].nil?
        return details
      end
    end

    private

    def outdated_software
      audit.select { |key, value| ['Update', 'Exploitable'].include? audit[key][:status] }
    end
  end
end
