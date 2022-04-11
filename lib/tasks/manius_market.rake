# frozen_string_literal: true

namespace :manius_market do
  desc 'TODO'
  task start_cockroach_db: :environment do
    puts 'Starting local CockroachDB'
    puts "If you see an error, you probably don't have it installed or it is already running"
    system 'cockroach start --insecure --store=node1 --listen-addr=localhost:26257 --http-addr=localhost:8080 --join=localhost:26257,localhost:26258,localhost:26259 --background'
    system 'cockroach init --insecure --host=localhost:26257'
    puts 'Local CockroachDB started'
  end
end
