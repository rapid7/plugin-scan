module PluginScan
  class Links < Struct.new(:name)
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
       "Google Chrome" => "http://google.com/chrome"
       }
      return links[name]
    end
  end
end

