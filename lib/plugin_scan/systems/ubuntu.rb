module PluginScan
  module Systems
    class Ubuntu < Struct.new(:user_agent)
      def os
        'ubuntu'
      end

      def feature
        case
          when /Linux i686/
            "Linux running on Intel Prentium Pro CPU"
        end   
      end

      def os_fullname
        'Ubuntu Linux'
      end

      def os_version
        nil
      end

      def platform
        'Ubuntu'
      end

    end
  end
end

