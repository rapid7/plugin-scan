# Usage:
#
# irb > client = PluginScan::Client.new('Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.91 Safari/537.11')
# => #<struct PluginScan::Client ua="Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.91 Safari/537.11"> 
# irb > client.platform
# => "Linux (Generic)" 
# irb > client.os
# => "linux" 
# irb > client.browser
# => "chrome" 
# irb > client.browser_fullname
# => "Google Chrome"
# irb > client.browser_version
# => "23.0.1271.91"

module PluginScan

  class Client < Struct.new(:ua, :params, :ip, :request)

    def audit
      PluginScan::Software.audit(browser_fullname, software, current_releases, security_releases, os)
    end

    def browser
      PluginScan::Browser.name(ua)
    end

    def browser_fullname
      PluginScan::Browser.fullname(ua)
    end

    def browser_version
      PluginScan::Browser.version(ua)
    end

    def country
      PluginScan::Geo.country(ip)
    end

    def exploits     
    end

    def feature
      PluginScan::System.feature(ua)
    end

    def feed
      params[:fid][0,32] unless params[:fid].nil?
    end

    def details
      PluginScan::Details.new(browser, browser_fullname, country, feed, ip, os, os_fullname, referer, software, user_agent)
    end

    def ip
      request.remote_ip
    end

    def issues
      PluginScan::Issues.new(audit, country, feed, ip)
    end

    def language
      PluginScan::Language.detect(request)
    end

    def metasploit 
    end
    
    def os
      PluginScan::System.os(ua)
    end

    def os_fullname
      PluginScan::System.os_fullname(ua)
    end

    def os_version
      PluginScan::System.os_version(ua)
    end

    def platform
      PluginScan::System.platform(ua)
    end

    def referer
      PluginScan::Referer.detect(request)
    end

    def software
      PluginScan::Software.detect(browser_fullname, browser_version, params)
    end

    def current_releases
      PluginScan::Software.current_releases(os, browser, browser_fullname)
    end

    def security_releases
      PluginScan::Software.security_releases(os, browser, browser_fullname)
    end

    # Returns array of hashes for vulnerabilities ie. CVE, Exploit DB, OSVDB
    def vulns
      [{"CVE-0000" => 'CVE Data'}, {'OSVDB-0000' => 'OSVDB Data'}]
    end

    def user_agent
      return ua
    end
  end
end

