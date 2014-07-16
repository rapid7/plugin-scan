module UseCases
  class FindsReferrerStats
    LIMIT = 100

    def find_stats(feed_id, duration)
      stats = find_by(feed_id, duration)
      counts = aggregate_counts(stats)
      records = convert_to_array(counts)
      sorted_records = sort_by_count(records)
      ReferrerStats.new(sorted_records)
    end

    private

    def find_by(feed_id, duration)
      Repositories::DailyStatsRepository.find_by_feed_and_duration(feed_id, duration)
    end

    def aggregate_counts(stats)
      totals = {}
      stats.each do |stat|
        stat.get_values_for(:referrers).each do |referrer|
          ip = referrer['host']
          count = referrer['count']
          if totals.has_key?(ip)
            totals[ip] += count
          else
            totals[ip] = count
          end
        end
      end
      totals
    end

    def convert_to_array(counts)
      counts.map do |k, v|
        OpenStruct.new(value: k, count: v)
      end
    end

    def sort_by_count(records)
      records.sort { |x, y| y.count <=> x.count }.take(LIMIT)
    end
  end
end
