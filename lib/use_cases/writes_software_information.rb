module UseCases
  class WritesSoftwareInformation
    def write(tid, report)
      write_daily_stats(report.hit_versions, report.outdated_versions)
      write_hit(tid, report.hit_versions)
      write_exploitable(tid, report.outdated_versions)
    end

    private

    def write_daily_stats(hit, failures)
      visit = Visit.new(hit: hit, failures: failures)
      UseCases::WritesDailyStats.new.write(visit)
    end

    def write_hit(tid, hit)
      UseCases::CreatesHits.create(tid, hit)
    end

    def write_exploitable(tid, outdated)
      UseCases::CreatesExploitables.create(tid, outdated)
    end
  end
end
