# frozen_string_literal: true

max_threads = Integer(ENV.fetch("RAILS_MAX_THREADS") { 5 })
min_threads = Integer(ENV.fetch("RAILS_MIN_THREADS") { 1 })
threads min_threads, max_threads

port ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "production" }

workers Integer(ENV.fetch("WEB_CONCURRENCY") { 2 })
preload_app!

plugin :tmp_restart
