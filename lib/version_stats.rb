class VersionStats
  def initialize(addon_id, stats)
    @addon_id = addon_id
    @stats = stats
    @software_names = SoftwareNames.new
  end

  def count_per_version
    @stats.collect do |stat|
      "['#{full_name} #{version(stat)}', #{stat.count}]"
    end
  end

  private

  def full_name
    sanitize(@software_names.get_full_name(@addon_id))
  end

  def version(stat)
    version = stat.value
    sanitize(version.gsub("\,","\."))
  end

  def sanitize(str)
    str.gsub(/[^\x20-\x7f]+/, '').gsub(/[\x22\x27]/, '')
  end
end
