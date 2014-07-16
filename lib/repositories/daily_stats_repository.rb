module Repositories
  class DailyStatsRepository
    def self.find_by_feed_and_duration(feed_id, duration)
      DailyStats.where(:fid => feed_id, 
                       :date.gte => duration.start_date, 
                       :date.lte => duration.end_date)
    end
  end
end
