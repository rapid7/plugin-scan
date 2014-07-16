module PluginScan
  module System
    class << self
      def parse(user_agent)
        case user_agent
          when /ubuntu/i
            PluginScan::Systems::Ubuntu.new(user_agent)
          when /linux/i
            PluginScan::Systems::Linux.new(user_agent)
          when /macintosh/i
            PluginScan::Systems::Macintosh.new(user_agent)
          when /windows/i
            PluginScan::Systems::Windows.new(user_agent)
          else
            PluginScan::Systems::UnknownSystem.new
        end
      end
   
      def feature(user_agent)
        parse(user_agent).feature
      end

      def os(user_agent)
        parse(user_agent).os
      end

      def os_fullname(user_agent)
        parse(user_agent).os_fullname
      end

      def os_version(user_agent)
        parse(user_agent).os_version
      end

      def platform(user_agent)
        parse(user_agent).os
      end
    end
  end
end




