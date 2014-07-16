module PluginScan
  module Browsers
    class Firefox < Struct.new(:user_agent)
      def name
        'firefox'
      end

      def fullname
        'Mozilla Firefox'
      end

      def version
        user_agent.split()[-1].split("\/")[1]
      end
    end
  end
end

