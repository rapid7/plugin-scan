class SoftwareStats
  def initialize(stats)
    @stats = stats
    @software_names = SoftwareNames.new
  end

  def count_per_name
    @stats.collect { |stat| "['#{software_name(stat)}', #{stat.count}]" }
  end

  def names
    @stats.collect { |stat| "'#{software_name(stat)}'" }
  end

  def counts
    @stats.collect { |stat| "#{stat.count}" }
  end

  private

  def software_name(stat)
    sanitize(@software_names.get_full_name(stat.value) || stat.value)
  end

  def sanitize(str)
    str.gsub(/[^\x20-\x7f]+/, '').gsub(/[\x22\x27]/, '')
  end
end
