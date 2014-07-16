require 'ostruct'

module UseCases
  class FindsBrowserStats
    def find_stats(feed_id, duration)
      stats = find_by(feed_id, duration)
      counts = aggregate_counts(stats)
      records = convert_to_array(counts) 
      sorted_records = sort_by_count(records)
    end

    private

    def find_by(feed_id, duration)
      Repositories::DailyStatsRepository.find_by_feed_and_duration(feed_id, duration)
    end

    def aggregate_counts(stats)
      results = {}
      stats.each do |stat|
        stat.get_values_for(:browsers).each do |h|
          name = h['browser']
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
