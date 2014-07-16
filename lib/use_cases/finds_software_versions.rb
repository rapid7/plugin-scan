module UseCases
  class FindsSoftwareVersions
    def find_versions(feed_id, duration, addon_id)
      stats   = find_by(feed_id, duration)
      records = hash_addon_version_counts_for(addon_id, stats)
      VersionStats.new(addon_id, convert_to_array(records))
    end

    private

    def find_by(feed_id, duration)
      Repositories::DailyStatsRepository.find_by_feed_and_duration(feed_id, duration)
    end

    def hash_addon_version_counts_for(name, stats)
      totals = {}
      stats.each do |stat|
        stat.get_values_for(name).each do |detail|
          version = detail['version']
          count = detail['count']
          if totals.has_key?(version)
            totals[version] += count
          else
            totals[version] = count
          end
        end
      end
      totals
    end

    def convert_to_array(totals)
      totals.map do |k, v|
        OpenStruct.new(value: k, count: v)
      end
    end
  end
end
