module PluginScan
  class Vulns < Struct.new(:os,:browser,:browser_version,:plugins)
    def search 
      return nil
    end
  end
end

=begin
Vulnerability
	Name
	Exploitable
	Malware
	Platform
	Software
		Min
		Max
	Metasploit
	Explots (an array of Exploit objects)

Exploit
	Type
	Name
	Info
	Platform




=end
