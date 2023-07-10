#!/usr/bin/env ruby

puts "Setup templates"
template_directory = "/usr/local/share/decidim/templates"
template_motd = ERB.new(File.read(File.join(template_directory, "motd.txt.erb")))
supervisord_motd = ERB.new(File.read(File.join(template_directory, "supervisord.conf.erb")))

File.write("/etc/motd", template_motd.result_with_hash(
	decidim_version: ENV.fetch("ROOT"),
	root: ENV.fetch("ROOT"),
	rails_env: ENV.fetch("RAILS_ENV"),
	ruby_version: ENV.fetch("RUBY_VERSION")
))

File.write(File.join(ENV.fetch("ROOT"), "/config/supervisord.conf"), supervisord_motd.result_with_hash(
	root: ENV.fetch("ROOT"),
	run_rails: ENV.fetch("DECIDIM_RUN_RAILS", "0") == "1",
	run_sidekiq: ENV.fetch("DECIDIM_RUN_CRON", "0") == "1",
	run_cron: ENV.fetch("DECIDIM_RUN_CRON", "0") == "1"
))
puts "    ✅ /etc/motd updated"
puts "    ✅ $ROOT/config/supervisord.conf updated"