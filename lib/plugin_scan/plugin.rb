module PluginScan
  module Plugin
    def self.check(os,browser,plugin,version) 
      case plugin
        when /dvr/
          PluginScan::Plugins::Checks::DVR.new(os,browser,plugin,version)
        when /flash/
          PluginScan::Plugins::Checks::Flash.new(os,browser,plugin,version)
        when /java/
          PluginScan::Plugins::Checks::Java.new(os,browser,plugin,version)
        when /qt/
          PluginScan::Plugins::Checks::Quicktime.new(os,browser,plugin,version)
        when /reader/
          PluginScan::Plugins::Checks::AdobeReader.new(os,browser,plugin,version)
        when /silver/
          PluginScan::Plugins::Checks::Silverlight.new(os,browser,plugin,version)
        when /rp/
          PluginScan::Plugins::Checks::RealPlayer.new(os,browser,plugin,version)
        when /shock/
          PluginScan::Plugins::Checks::Shockwave.new(os,browser,plugin,version)
        when /wmp/
          PluginScan::Plugins::Checks::WMP.new(os,browser,plugin,version)
        when /vlc/
          PluginScan::Plugins::Checks::VLC.new(os,browser,plugin,version)
        else
          nil
      end
    end
  end
end


=begin

@client.plugins.keys : ["Adobe Reader", "Phoscode DevalVR", "Adobe Flash", "Oracle Java", "Apple Quicktime", "RealPlayer", "Adobe Shockwave", "Microsoft Silverlight", "Windows Media Player", "VLC Media Player"]

=end
