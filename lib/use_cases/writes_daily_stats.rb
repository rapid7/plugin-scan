module UseCases
  class WritesDailyStats
    def initialize(factory=Stats::WriterFactory.new)
      @factory = factory
    end

    def write(visit)
      document = find_document(visit.feed_id, visit.date)
      write_stats(document, visit)
    end

    private

    def find_document(feed_id, date)
      DailyStats.find_or_create_by(fid: feed_id, date: date)
    end

    def write_stats(document, visit)
      writers.each do |writer|
        writer.write(document, visit)
      end
    end

    def writers
      @writers ||= @factory.all_writers
    end
  end
end
