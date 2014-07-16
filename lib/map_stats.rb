class MapStats
  def initialize(stats)
    @stats = stats
  end

  def count_per_country
    @stats.collect { |stat| "['#{sanitize(stat.value)}', #{stat.count}]" }
  end

  private

  def sanitize(str)
    str.gsub(/[^\x20-\x7f]+/, '').gsub(/[\x22\x27]/, '')
  end
end
