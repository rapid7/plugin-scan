module PluginScan
  module Systems
    class Linux < Struct.new(:ua)
      def os
        'linux'
      end

      def feature
        case
          when /Linux i686/
            "Linux running on Intel Prentium Pro CPU"
        end       
      end

      def platform
        case ua
          when /chrome/
            ua.split(';')[1].split(')')[0].strip
          when /firefox/
            ua.split(';')[1].strip
          else
            'Linux (Generic)'
        end
      end  

      def os_fullname
        'Linux (Unknown)'
      end

      def os_version
        nil
      end

    end
  end
end

