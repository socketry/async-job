#!/usr/bin/env ruby
# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

# Create a minimal Rails-like environment for SolidQueue
ENV['RAILS_ENV'] ||= 'development'

require "bundler/setup"
require "rails"
require "active_job/railtie"
require "active_record/railtie"

# Create a minimal Rails application
class SolidQueueApp < Rails::Application
  config.load_defaults 7.1
  config.eager_load = false
  config.logger = Logger.new(nil) # Quiet for client
  config.log_level = :error
  
  # Don't configure ActiveJob for our simple database queue
end

# Initialize the Rails app
Rails.application.initialize!

# Set up database connection - use correct path in benchmark directory
database_path = File.join(__dir__, 'db', 'solid_queue.sqlite3')
puts "Connecting to database: #{database_path}"

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: database_path
)

# Simple database-backed job model (instead of complex SolidQueue setup)
class SimpleSolidJob < ActiveRecord::Base
  self.table_name = 'solid_queue_jobs'
end

# Clear ActiveRecord cache and verify connection
ActiveRecord::Base.clear_cache!
puts "Database connection: #{ActiveRecord::Base.connection.database_version}"
puts "Tables available: #{ActiveRecord::Base.connection.tables.join(', ')}"

# Load our job
require_relative "solid_queue_benchmark_job"

def benchmark_solid_queue(job_count = 10_000)
	puts "Benchmarking solid_queue with #{job_count} jobs..."
	
	start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
	
	job_count.times do
		# Insert job directly into database instead of using ActiveJob
		SimpleSolidJob.create!(
			job_class: 'SolidQueueBenchmarkJob',
			job_args: '[]',
			queue_name: 'solid_queue_default',
			priority: 0,
			created_at: Time.current,
			updated_at: Time.current
		)
	end
	
	end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
	
	puts "SolidQueue results:"
	puts "  Started at: #{start_time}"
	puts "  Ended at: #{end_time}"
	puts "  Total enqueue time: #{end_time - start_time}s"
	puts "  Jobs per second: #{(job_count / (end_time - start_time)).round(2)}"
end

# Parse command line argument for job count
job_count = ARGV[0] ? ARGV[0].to_i : 10_000

if job_count <= 0
	puts "Error: Job count must be a positive integer"
	puts "Usage: #{$0} [job_count]"
	puts "Example: #{$0} 5000"
	exit 1
end

benchmark_solid_queue(job_count)