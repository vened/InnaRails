#!/usr/bin/env puma

directory '/home/deploy/www/InnaRails'
rackup "/home/deploy/www/InnaRails/config.ru"
environment 'production'

pidfile "/home/deploy/www/InnaRails/tmp/puma.pid"
state_path "/home/deploy/www/InnaRails/tmp/puma.state"
stdout_redirect '/home/deploy/www/InnaRails/log/puma_access.log', '/home/deploy/www/InnaRails/log/puma_error.log', true


threads 0,16

bind 'unix:///home/deploy/www/InnaRails/tmp/puma.sock'
workers 0



preload_app!

on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = "/home/deploy/www/InnaRails/Gemfile"
end



on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

