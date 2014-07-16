require 'ostruct'

module UseCases
  class FindsOperatingSystemStats
    def find_stats(feed_id, duration)
      stats = find_by(feed_id, duration)
      counts = aggregate_counts(stats,duration)
      records = convert_to_array(counts) 
      sort_by_count(records)
    end

    private

    def find_by(feed_id, duration)
      Repositories::DailyStatsRepository.find_by_feed_and_duration(feed_id, duration)
    end

    def aggregate_counts(stats,duration)
      results = {}
      stats.each do |stat|
        stat.get_values_for(:oses).each do |h|
          name = h['os']
          count = h['count']

          if results.has_key?(name)
            results[name] += count
          else
            results[name] = count
          end
        end
      end
      results
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
