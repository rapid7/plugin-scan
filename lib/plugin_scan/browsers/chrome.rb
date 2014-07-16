module PluginScan
  module Browsers
    class Chrome < Struct.new(:user_agent)
      def name
        'chrome'
      end

      def fullname
        'Google Chrome'
      end

      def version
        user_agent.split()[-2].split("\/")[1]
      end
    end
  end
end

