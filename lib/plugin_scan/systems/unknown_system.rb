module PluginScan
  module Systems
    class UnknownSystem < Struct.new(:user_agent)
      def os
        'unknown'
      end

      def feature
      end
      
      def platform
        'Unknown'
      end

      def os_version
      end

      def os_fullname
        'Unknown'
      end
    end
  end
end

