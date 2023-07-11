#!/usr/bin/env ruby
pid_file = ENV.fetch("RAILS_PID_FILE", "tmp/pids/server.pid")
File.delete(pid_file) if File.exists?(pid_file)
puts "    ✅ Puma pid is removed"