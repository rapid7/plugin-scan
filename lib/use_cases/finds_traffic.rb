module UseCases
  class FindsTraffic
    def self.find_for(feed, duration)
      stats = Repositories::DailyStatsRepository.find_by_feed_and_duration(feed.fid, duration)
      new(stats.collect(&:create_traffic), duration)
    end

    def initialize(traffic, duration)
      @traffic = traffic
      @dates   = duration.as_dates
    end

    def dates
      @dates
    end

    def hits_per_date
      dates.collect do |date|
        idx = @traffic.index { |x| x.date == date }
        if idx
          @traffic[idx].hit
        else
          0
        end
      end
    end

    def outdated_per_date
      dates.collect do |date|
        idx = @traffic.index { |x| x.date == date }
        if idx
          @traffic[idx].outdated
        else
          0
        end
      end
    end

    def to_s
      s = ""
      combined_counts.each do |data|
        day = data[0].strftime("%m/%d").gsub(/^0/, '').gsub(/\/0/, '/') 
        s += ", " unless s.empty?
        s += "['#{day}', #{data[1]}, #{data[2]}]"  
      end
      s.html_safe
    end

    private

    def combined_counts
      dates.zip(hits_per_date, outdated_per_date)
    end
  end
end
