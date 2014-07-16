module PluginScan
  module Browsers
    class IE < Struct.new(:user_agent)
      def name
        'ie'
      end

      def fullname
        case user_agent
          when /Trident\/6\.0/
            "Internet Explorer 10"
          when /Trident\/5\.0/
            "Internet Explorer 9"
          when /Trident\/4\.0/
            "Internet Explorer 8"
          when /MSIE 10\.0/
            "Internet Explorer 10"
          when /MSIE 9\.0/
            "Internet Explorer 9"
          when /MSIE 8\.0/
            "Internet Explorer 8"
          when /MSIE 7\.0/
            "Windows Internet Explorer 7"
          when /MSIE 6\.0/
            "Microsoft Internet Explorer 6"
          else
            "Internet Explorer"
        end
      end

      def version
        case user_agent
          when /Trident\/6\.0/
            "10"
          when /Trident\/5\.0/
            "9"
          when /Trident\/4\.0/
            "8"
          when /MSIE 10\.0/
            "10"
          when /MSIE 9\.0/
            "9"
          when /MSIE 8\.0/
            "8"
          when /MSIE 7\.0/
            "7"
          when /MSIE 6\.0/
            "6"
          else
            nil
        end
      end
    end
  end
end

