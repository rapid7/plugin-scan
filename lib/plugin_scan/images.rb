module PluginScan
  class Images < Struct.new(:name,:size)
    def self.render(name,size)
      "<img src=\"/assets/icon_#{ shortname(name) }_#{ scale(size) }.png\" class=\"img-rounded\">"
    end

    def self.scale(size)
      case size
      when 16
        '16x16'        
      when 32
        '32x32'        
      when 48
        '48x48'
      end
    end

    def self.shortname(name)
      software = { 'Adobe Reader' => 'reader',
                   'Phoscode DevalVR' => 'dvr',
                   'Adobe Flash' => 'flash',
                   'Oracle Java' => 'java',
                   'Apple Quicktime' => 'quicktime',
                   'RealPlayer' => 'rp',
                   'Adobe Shockwave' => 'shockwave',
                   'Microsoft Silverlight' => 'silverlight',
                   'Windows Media Player' => 'wmp',
                   'VLC Media Player' => 'vlc',
                   'Google Chrome' => 'chrome',
                   'Apple Safari' => 'safari',
                   'Mozilla Firefox' => 'firefox',
                   'Internet Explorer' => 'ie' }
      case name
      when /internet explorer/i
       'ie'
      when /macintosh/i
        'macintosh'
      when /ubuntu/i
        'ubuntu'
      when /windows/i
        'windows'
      when /linux/i
        'linux'
      when /unknown/i
        'unknown'
      else
        return software[name]
      end      
    end
  end
end

