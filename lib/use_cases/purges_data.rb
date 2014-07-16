module UseCases
  class PurgesData
    def purge_by_feed(feed_id)
      DailyStats.where(fid: feed_id).delete
    end
  end
end
