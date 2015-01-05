#!/usr/bin/env ruby
require 'benchmark'

time = Benchmark.realtime do
  database = ARGV.shift
  username = 'root'
  password = nil
  iteration_name = ARGV.shift
  backup_file = database + '-' + Time.now.strftime("%Y%m%d")

  if !iteration_name.nil?
    backup_file = database + '-' + iteration_name
  end

  # Don't Ask for password if you connect to yours DB without password
  # http://stackoverflow.com/questions/9293042/mysqldump-without-the-password-prompt

  puts "\ncreating mysql dump for #{database}"
  if password.nil?
    `mysqldump -u#{username} #{database} > backup/#{backup_file}.sql`
  else
    `mysqldump -u#{username} -p#{password} #{database} > backup/#{backup_file}.sql`
  end

  puts "\ncompressing database..."
  `gzip backup/#{backup_file}.sql`
end

puts "\nTime elapsed #{time*1000} milliseconds"