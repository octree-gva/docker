#!/usr/bin/env ruby

# Wait for postgres to be available for connections
database_address = ENV.fetch("DATABASE_URL").match(/.*@([^\/]+).*/)[1]
`wait-for-it "#{database_address}" -t 60`

queue_adapter = ENV.fetch("QUEUE_ADAPTER", "default")
if queue_adapter == "sidekiq"
  redis_address = ENV.fetch("REDIS_URL").match(/.*@([^\/]+).*/)[1]
  `wait-for-it "#{redis_address}" -t 60`
end

puts "    ✅ databases are ready"