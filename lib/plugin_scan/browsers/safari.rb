module PluginScan
  module Browsers
    class Safari < Struct.new(:user_agent)
      def name
        'safari'
      end

      def fullname
        'Apple Safari'
      end

      def version
        user_agent.split()[-1].split("\/")[1]
      end
    end
  end
end

