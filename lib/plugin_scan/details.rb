module PluginScan
  class Details < Struct.new(:browser, :browser_fullname, :country, :feed, :ip, :os, :os_fullname, :referer, :software, :user_agent)
      def to_h
        details = {
          'Feed' => feed,
          'IP Address' => ip,
          'OS' => os_fullname,
          'User Agent' => user_agent,
          'Referer' => referer, 
        }
        details.merge!(software)
      end

      def to_s
        to_h.map{|k,v| "#{k}: #{v}"}.join('\n')
      end

      def to_html
        to_h.map{|k,v| "#{k}: #{v}"}.join('<br>')
      end

      def to_mongo
        software = to_h
        details = {}
        details[:fid] = feed unless feed.nil?
        details[:country] = country unless country.nil?
        details[:os] = os unless os.nil?
        details[:br] = browser unless browser.nil?
        details[:br_v] = software[browser_fullname] unless software[browser_fullname].nil?        
        details[:ua] = software['User Agent'] unless software['User Agent'].nil?
        details[:rf] = software['Referer'] unless software['Referer'].nil?
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
end

