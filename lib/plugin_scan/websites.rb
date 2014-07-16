module PluginScan
  class Websites < Struct.new(:name)
    def self.link(name)
      links = {
       "Adobe Reader" => "http://get.adobe.com/reader/",
       "Phoscode DevalVR" => "http://www.devalvr.com",
       "Adobe Flash" => "http://get.adobe.com/flashplayer/",
       "Oracle Java" => "http://www.java.com/getjava/",
       "Apple Quicktime" => "http://www.apple.com/quicktime/download/",
       "RealPlayer" => "http://www.real.com/realplayer",
       "Adobe Shockwave" => "http://get.adobe.com/shockwave/",
       "Microsoft Silverlight" => "http://www.microsoft.com/getsilverlight/",
       "Windows Media Player" => "http://windows.microsoft.com/en-US/windows/download-windows-media-player",
       "VLC Media Player" => "http://www.videolan.org/vlc/index.html",
       "Google Chrome" => "http://google.com/chrome",
       "Apple Safari" => "http://www.apple.com/safari/",
       "Mozilla Firefox" => "http://www.mozilla.org/firefox/"
       }
      if name =~ /Internet Explorer/
        return "http://www.microsoft.com/en-us/download/ie.aspx?q=internet+explorer"
      else
        return links[name]
      end
    end
  end
end

