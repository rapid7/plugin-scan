class DailyStats
	include Mongoid::Document
	include Mongoid::Timestamps::Created

  field :fid, type: String
  field :date, type: Date

  index({ fid: 1, date: 1 }, { unique: true })

  def get_values_for(name)
    if has_attribute?(name)
      values = read_attribute(name)
      if values.respond_to?(:length)
        values
      else
        [values]
      end
    else
      []
    end 
  end
  
  def create_traffic
    if has_attribute?(:traffic)
      total = traffic['total']
      outdated = traffic['outdated']
    else
      total = 0
      outdated = 0
    end
    new_traffic_stat(total, outdated)
  end

  private

  def new_traffic_stat(total, outdated)
    Stats::Traffic.new(date: date, hit: total, outdated: outdated)
  end
end
