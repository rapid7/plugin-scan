module PluginScan
  module Systems
    class Windows < Struct.new(:ua)
      def os
        'windows'
      end

      def feature
        case ua
          when /\.NET CLR/
            ".NET Framework common language run time, followed by the version number."
          when /SV1/
            "Internet Explorer 6 with enhanced security features (Windows XP SP2 and Windows Server 2003 only)."
          when /Tablet PC/
            "Tablet services are installed."
          when /Win64; IA64/
            "System has a 64-bit processor (Intel)."
          when /Win64; x64/
            "System has a 64-bit processor (AMD)."
          when /WOW64/
            "A 32-bit version of browser is running on a 64-bit processor."
        end
      end

      def platform
        case ua
          when /Windows NT 6\.2/
            "Windows 8"
          when /Windows NT 6\.1/
            "Windows 7"
          when /Windows NT 6\.0/ 
            "Windows Vista"
          when /Windows NT 5\.2/
            "Windows Server 2003; Windows XP x64 Edition"
          when /Windows NT 5\.1/
            "Windows XP"
          when /Windows NT 5\.01/
            "Windows 2000, Service Pack 1 (SP1)"
          when /Windows NT 5\.0/
             "Windows 2000"
          when /Windows NT 4\.0/
            "Windows NT 4.0"
          when /Windows 98; Win 9x 4\.90/
            "Windows Millennium Edition (Windows Me)"
          when /Windows 98/
            "Windows 98"
          when /Windows 95/
            "Windows 95"
          when /Windows CE/
            "Windows CE"
          else
            "Windows (Unknown)"
        end
      end

      def os_fullname
        'Microsoft ' + platform
      end

      def os_version
               case ua
          when /Windows NT 6\.2/
            "Windows NT 6.2"
          when /Windows NT 6\.1/
            "Windows NT 6.1"
          when /Windows NT 6\.0/ 
            "Windows NT 6.0"
          when /Windows NT 5\.2/
            "Windows NT 5.2"
          when /Windows NT 5\.1/
            "Windows NT 5.1"
          when /Windows NT 5\.01/
            "Windows NT 5.01"
          when /Windows NT 5\.0/
             "Windows NT 5.0"
          when /Windows NT 4\.0/
            "Windows NT 4.0"
          when /Windows 98; Win 9x 4\.90/
            "Windows 98"
          when /Windows 98/
            "Windows 98"
          when /Windows 95/
            "Windows 95"
          when /Windows CE/
            "Windows CE"
          else
            "Windows (Unknown)"
        end
      end

    end
  end
end

