class Duration < Struct.new(:start_time, :end_time, :days)
  class << self
    def between(start_time, end_time)
      number_of_days = ((end_time.to_i - start_time.to_i) / (24 * 3600)).to_i
      Duration.new(start_time, end_time, number_of_days)
    end

    def for_days_prior(n)
      Duration.new(Time.now.utc - n.days, Time.now.utc, n) 
    end

    def between_seconds(start_seconds, end_seconds)
      start_time = Time.at(start_seconds).utc
      end_time   = Time.at(end_seconds).utc
      Duration.new(start_time, end_time)
    end
  end

  def start_date
    start_time.to_date
  end

  def end_date
    end_time.to_date
  end

  def as_dates
    [].tap do |arr|
      date = start_date
      while date <= end_date do
        arr << date
        date = date.next_day
      end   
    end 
  end
end
