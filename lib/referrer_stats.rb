class ReferrerStats
  def initialize(stats)
    @stats = stats
  end

  def ordered_referrers
    raw = {}
    @stats.each do |stat|
      ref = stat.value

      # XXX: This is the old format and can be removed once we go live
      if ref.to_s.index('/')
        ref = URI.parse(ref).host rescue ""
      end

      raw[ref] ||= 0
      raw[ref]  += stat.count
    end

    # Limit to the top 100 referers
    referers = {}
    raw.keys.sort{|a,b| raw[b] <=> raw[a] }[0,100].each do |r|
      referers[r] = raw[r]
    end
    referers
  end
end
