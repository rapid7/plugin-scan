class ExposureStats
  def initialize(total, outdated)
    @total = total.to_i
    @outdated = outdated.to_i
  end

  def number_of_current
    @total - @outdated
  end

  def number_of_outdated
    @outdated
  end

  def count_per_stat
    [ "['Current', #{number_of_current}]", "['Outdated', #{number_of_outdated}]" ]
  end
end
