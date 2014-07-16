module PluginScan
  module Browser
    class << self
      def parse(user_agent)
        case user_agent
          when /chromium/i
            PluginScan::Browsers::Chromium.new(user_agent)
          when /chrome/i
            PluginScan::Browsers::Chrome.new(user_agent)
          when /safari/i
            PluginScan::Browsers::Safari.new(user_agent)
          when /firefox/i
            PluginScan::Browsers::Firefox.new(user_agent)
          when /msie/i
            PluginScan::Browsers::IE.new(user_agent)
          else
            PluginScan::Browsers::UnknownBrowser.new
        end
      end

      def name(user_agent)
        parse(user_agent).name
      end

      def fullname(user_agent)
        parse(user_agent).fullname
      end

      def version(user_agent)
        parse(user_agent).version
      end
    end
  end
end




