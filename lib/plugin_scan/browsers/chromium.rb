module PluginScan
  module Browsers
    class Chromium < Struct.new(:user_agent)
      def name
        'chromium'
      end

      def fullname
        'Google Chromium'
      end

      def version
        user_agent.split()[-3].split("\/")[1]
      end
    end
  end
end

