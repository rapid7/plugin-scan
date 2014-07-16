class IPStats
  def initialize(stats)
    @stats = stats
  end

  def ordered_ips
    @stats.inject({}) do |memo, stat|
      ip = stat.value
      count = stat.count
      memo[ip] = count
      memo
    end
  end
end
