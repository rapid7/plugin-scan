module PluginScan
  class Geo < Struct.new(:ip)
    def self.country(ip)
     begin
        $geoip_db ||= GeoIP.new("#{Rails.root}/vendor/data/GeoLiteCity.dat")
        $geoip_db.country(ip).country_name
      rescue
        return "None"
      end
    end
  end
end

