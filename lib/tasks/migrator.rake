namespace :migrator do
  desc 'Migrate Hit and Exploitable data for a given datetime range'
  task :migrate_between, [:start, :end] => [:environment] do |t, args|
    duration = Duration.between(args[:start].to_time, args[:end].to_time)
    puts DailyStatsMigrator.migrate_for_date_range(duration)
  end
end
