module UseCases
  class FindsMapStats
    def find_stats(feed_id, duration)
      stats = find_by(feed_id, duration)
      counts = aggregate_counts(stats)
      records = convert_to_array(counts)
      sorted_records = sort_by_count(records)
      MapStats.new(sorted_records) 
    end

    private

    def find_by(feed_id, duration)
      Repositories::DailyStatsRepository.find_by_feed_and_duration(feed_id, duration)
    end

    def aggregate_counts(stats)
      totals = {}
      stats.each do |stat|
        stat.get_values_for(:countries).each do |country|
          name = country['country']
          count = country['outdated_count']
          if totals.has_key?(name)
            totals[name] += count
          else
            totals[name] = count
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
      records.sort { |x, y| y.count <=> x.count }
    end
  end
end
