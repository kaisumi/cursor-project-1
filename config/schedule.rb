# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.day, at: '5:00 am' do
  rake "backup:all"
end

every 1.week, at: '6:00 am' do
  rake "backup:verify_database"
end

# Clean up old backups
every 1.month, at: '7:00 am' do
  command "find #{Rails.root.join('backups')} -name '*.sql' -mtime +30 -delete"
  command "find #{Rails.root.join('backups')} -name '*.tar.gz' -mtime +30 -delete"
end
