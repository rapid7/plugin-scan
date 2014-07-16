class TrafficChartPresenter
  def initialize(traffic)
    @traffic = traffic
    @id = sprintf("N%.8x%.8x", rand(0x100000000), rand(0x100000000))
  end

  def id
    @id
  end

  def tick_interval
    @traffic.dates.length >= 30 ? 3 : 1
  end

  def dates
    @traffic.dates.collect { |date| "'#{date.month}/#{date.day}'" }.join(', ').html_safe
  end

  def hits
    @traffic.hits_per_date.join(', ').html_safe
  end

  def outdated
    @traffic.outdated_per_date.join(', ').html_safe
  end
end
