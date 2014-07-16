module PluginScan
  module Systems
    class Macintosh < Struct.new(:user_agent)
      def os
        'macintosh'
      end

      def platform
        case user_agent
          when /safari/i # This handles Safari and Chrome
            user_agent.split(';')[1].split(')')[0].gsub('_','.').strip
          when /firefox/i
            user_agent.split(';')[1].strip
        end
      end    

      def feature
        case ua
          when /Intel Mac/
            "Macintosh on an Intel CPU"
        end
      end

      def os_fullname
        'Apple Macintosh OS X'
      end

      def os_version
        platform.split[-1]
      end

    end
  end
end

