class Visit
  attr_reader :date, :hit, :failures

  def self.for_hit(hit)
    new(date: hit.created_at, hit: hit.to_hash)
  end

  def self.for_failures(failures)
    new(date: failures.created_at, failures: failures.to_hash)
  end

  def initialize(args={})
    @date     = args.fetch(:date, Time.now.utc.to_date)
    @hit      = args.fetch(:hit, {})
    @failures = args.fetch(:failures, {})
  end

  def feed_id
    if has_hit?
      hit[:fid]
    else
      failures[:fid]
    end
  end

  def has_hit?
    hit.count > 0 
  end

  def has_failures?
    failures.count > 0
  end
end
