module UseCases
  class FindsTrafficResults
    def find_all(feed_id, duration)
      stats = find_by(feed_id, duration)
      hits  = hash_counts_for('total', stats)
      vulns = hash_counts_for('outdated', stats)
      TrafficResults.new(duration.days, hits, vulns)
    end

    def find_by_addon(feed_id, addon_id, duration)
      stats = find_by(feed_id, duration)
      name  = addon_id[3..addon_id.size]
      hits  = hash_addon_counts_for(name, stats)
      vulns = hash_addon_outdated_counts_for(name, stats)
      TrafficResults.new(duration.days, hits, vulns)
    end

    private

    def find_by(feed_id, duration)
      Repositories::DailyStatsRepository.find_by_feed_and_duration(feed_id, duration)
    end

    def hash_counts_for(name, stats)
      totals = {}
      stats.each do |stat|
        if stat.has_attribute?(:traffic)
          date = stat.date
          formatted_date = "#{date.year}-#{date.month}-#{date.day}"
          totals[formatted_date] = stat.traffic.fetch(name, 0)
        end
      end
      totals
    end

    def hash_addon_counts_for(name, stats)
      totals = {}
      stats.each do |stat|
        date = stat.date
        formatted_date = "#{date.year}-#{date.month}-#{date.day}"
        totals[formatted_date] = 0
        stat.get_values_for(:addons).each do |addon|
          if addon['name'] == name
            totals[formatted_date] = addon['count']
          end
        end
      end
      totals
    end

    def hash_addon_outdated_counts_for(name, stats)
      totals = {}
      stats.each do |stat|
        count = 0
        stat.get_values_for(name).each do |detail|
          count += detail['count'] if detail['outdated']
        end
        date = stat.date
        formatted_date = "#{date.year}-#{date.month}-#{date.day}"
        totals[formatted_date] = count
      end
      totals
    end
  end
end
