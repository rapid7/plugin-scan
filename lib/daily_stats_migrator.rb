require 'stringio'

class DailyStatsMigrator
  attr_reader :writer, :duration, :output

  def self.migrate_for_date_range(duration)
    migrator = new({:duration => duration})
    migrator.migrate
  end

  def initialize(args={})
    @writer   = args.fetch(:writer, UseCases::WritesDailyStats.new)
    @duration = args.fetch(:duration)
    @output   = StringIO.new
  end

  def migrate
    output.write("Date range: #{duration.start_time} - #{duration.end_time}\n")

    hit_count = migrate_hits
    output.write("Hit records processed: #{hit_count}\n")

    exploit_count = migrate_exploits
    output.write("Exploitable records processed: #{exploit_count}\n")

    output.string
  end

  private

  def migrate_hits
    count = 0
    records_for(Hit).each do |hit|
      migrate_a_hit(hit)
      count += 1
    end
    count
  end

  def migrate_a_hit(hit)
    writer.write(Visit.for_hit(hit))
  end

  def migrate_exploits
    count = 0
    records_for(Exploitable).each do |exploit|
      migrate_an_exploit(exploit)
      count += 1
    end
    count
  end

  def migrate_an_exploit(exploit)
    writer.write(Visit.for_failures(exploit))
  end

  def records_for(klass)
    klass.where(:created_at.gte => @duration.start_time, :created_at.lte => @duration.end_time)
  end
end
