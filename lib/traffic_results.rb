class TrafficResults < Struct.new(:number_of_days, :hits, :vulns)
  def days
    date_range.collect { |date| "'#{month_day_format(date)}'" }
  end

  def hits_per_day
    date_range.collect { |date| "#{hit_count_on(date)}" }
  end

  def exploitable_per_day
    date_range.collect { |date| "#{vuln_count_on(date)}" }
  end

  def totals_per_day
    date_range.collect do |date|
      day   = month_day_format(date)
      hits  = hit_count_on(date)
      vulns = vuln_count_on(date)
      "['#{day}', #{hits}, #{vulns}]"
    end
  end

  def hit_count_on(date)
    key = iso_8601_format(date)
    hits.fetch(key, 0)
  end

  def vuln_count_on(date)
    key = iso_8601_format(date)
    vulns.fetch(key, 0)
  end

  private

  def date_range
    number_of_days.downto(0).collect do |num|
      days_from_now(num)
    end
  end

  def days_from_now(number)
    Time.now.utc - number.days
  end

  def iso_8601_format(date)
    date.strftime("%Y") + "-" + date.strftime("%m").sub(/^0/, '') + "-" + date.strftime("%d").sub(/^0/, '')
  end

  def month_day_format(date)
    date.strftime("%m").sub(/^0/, '') + "/" + date.strftime("%d").sub(/^0/, '')
  end
end
