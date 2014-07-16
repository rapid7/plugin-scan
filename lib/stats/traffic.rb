module Stats
  class Traffic
    attr_reader :date, :hit, :outdated

    def initialize(args={})
      @date     = args.fetch(:date, Time.now.utc.to_date)
      @hit      = args[:hit].to_i
      @outdated = args[:outdated].to_i
    end
  end
end
