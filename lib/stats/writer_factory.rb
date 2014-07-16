module Stats
  class WriterFactory
    def initialize
      @writers = create_writers
    end

    def all_writers
      @writers.dup
    end

    private 

    def create_writers
      [
        Writers::BrowserWriter.new,
        Writers::OperatingSystemWriter.new,
        Writers::TrafficWriter.new,
        Writers::AddonWriter.new,
        Writers::IpAddressWriter.new,
        Writers::ReferrerWriter.new,
        Writers::CountryWriter.new
      ]
    end
  end
end
