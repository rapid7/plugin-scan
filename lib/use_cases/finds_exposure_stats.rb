module UseCases
  class FindsExposureStats
    def find_exposures(feed_id, duration, addon)
      stats = find_by(feed_id, duration)
      all_versions = all_versions_of(addon, stats)
      outdated_versions = outdated_versions_of(addon, stats)
      ExposureStats.new(all_versions, outdated_versions)
    end
    private

    def find_by(feed_id, duration)
      Repositories::DailyStatsRepository.find_by_feed_and_duration(feed_id, duration)
    end

    def all_versions_of(name, stats)
      count = 0
      stats.each do |stat|
        stat.get_values_for(:addons).each do |addon|
          if addon['name'] == name
            count += addon['count']
          end
        end
      end 
      count
    end

    def outdated_versions_of(name, stats)
      count = 0
      stats.each do |stat|
        stat.get_values_for(name).each do |detail|
          count += detail['count'] if detail['outdated']
        end
      end
      count
    end
  end
end
