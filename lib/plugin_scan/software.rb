module PluginScan
  module Software
    class << self
      def detect(browser_fullname, browser_version, params)
        software = {}
        software[browser_fullname] = browser_version
        software['Adobe Reader'] = params[:reader][0,1024] unless params[:reader].nil?
        software['Phoscode DevalVR'] = params[:dvr][0,1024] unless params[:dvr].nil?
        software['Adobe Flash'] = params[:flash][0,1024] unless params[:flash].nil?
        software['Oracle Java'] = params[:java][0,1024] unless params[:java].nil?
        software['Apple Quicktime'] = params[:qt][0,1024] unless params[:qt].nil?
        software['RealPlayer'] = params[:rp][0,1024] unless params[:rp].nil?
        software['Adobe Shockwave'] = params[:shock][0,1024] unless params[:shock].nil?
        software['Microsoft Silverlight'] = params[:silver][0,1024] unless params[:silver].nil?
        software['Windows Media Player'] = params[:wmp][0,1024] unless params[:wmp].nil?
        software['VLC Media Player'] = params[:vlc][0,1024] unless params[:vlc].nil?
        return software
      end

      def current_releases(os, browser, browser_fullname)
        KnownVersions.new(os, browser, browser_fullname).current
      end

      def security_releases(os, browser, browser_fullname)
        KnownVersions.new(os, browser, browser_fullname).security
      end

      def version_check(detected_release, current_release, security_release)

        detected_release = detected_release.to_s.gsub(",",".")
        current_release  = current_release.to_s.gsub(",",".")
        security_release = security_release.to_s.gsub(",",".")

        detected = detected_release.split('.').map{|x| x.to_i}
        current  = current_release.split('.').map{|x| x.to_i}
        security = security_release.split('.').map{|x| x.to_i}

        detected.each_index do |i|
            if detected[i] > security[i].to_i
              return 'Supercedes'
            elsif security[i].to_i > detected[i]
              return 'Exploitable'
            elsif current[i].to_i > detected[i]
              return 'Update'
            end
        end

        if detected_release == current_release
          return 'Up to Date'
        else
          return 'Inconclusive'
        end
      end

      def find_vulns(status, software_specs)
        if (status == 'Update' || status == 'Exploitable') 
          UseCases::FindsVulnerabilities.find_for(software_specs)
        else
          []
        end
      end

      def find_exploits(status, software_specs)
        if (status == 'Update' || status == 'Exploitable') 
          UseCases::FindsExploits.find_for(software_specs)
        else
          {}
        end
      end

      def audit(browser_fullname, detected_software, current_releases, security_releases, os_short_name)
        detected_software.delete(browser_fullname)
        report = {}
        detected_software.keys.each do |key|
          result = version_check(detected_software[key], current_releases[key], security_releases[key])
          specs = SoftwareSpecs.new({ full_name: key,
                                      version: detected_software[key],
                                      os: os_short_name })
          report[key] = {
            detected:  detected_software[key], 
            current:   current_releases[key], 
            security:  security_releases[key], 
            status:    result,
            cve_vulns: find_vulns(result, specs),
            exploits:  find_exploits(result, specs)
          }
        end
        return report
      end
    end
  end
end
