#!/usr/bin/env ruby

# Check all the gems are installed or fails.
`bundle check`
puts "    ✅ Gems in Gemfiles are installed"

# Check no migrations are pending migrations
`bundle exec rails db:migrate`
puts "    ✅ Migrations are all up"