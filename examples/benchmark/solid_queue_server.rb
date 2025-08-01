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
  config.logger = Logger.new(STDOUT)
  config.log_level = :info
  
  # Database is configured via establish_connection
  
  # Don't configure ActiveJob for our simple database queue
end

# Initialize the Rails app
Rails.application.initialize!

# Set up database connection - use correct path in benchmark directory
database_path = File.join(__dir__, 'db', 'solid_queue.sqlite3')
puts "Server connecting to database: #{database_path}"

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: database_path
)

# Simple database-backed job model (instead of complex SolidQueue setup)
class SimpleSolidJob < ActiveRecord::Base
  self.table_name = 'solid_queue_jobs'
end

# Load our job  
require_relative "solid_queue_benchmark_job"

puts "Starting SolidQueue server..."
puts "Processing queue: solid_queue_default"
puts "Database: #{File.expand_path('../db/solid_queue.sqlite3', __dir__)}"
puts "Press Ctrl+C to stop"

# Simple worker loop using ActiveRecord  
def process_jobs
  loop do
    # Fetch unprocessed jobs
    job = SimpleSolidJob.where(queue_name: 'solid_queue_default', finished_at: nil)
                       .order(:created_at)
                       .first
    
    if job
      begin
        puts "Processing job #{job.id}: #{job.job_class}"
        
        # Execute the job
        job_class = job.job_class.constantize
        job_args = JSON.parse(job.job_args)
        job_class.new.perform(*job_args)
        
        # Mark as finished
        job.update!(finished_at: Time.current)
        puts "Job #{job.id} completed"
        
      rescue => e
        puts "Job #{job.id} failed: #{e.message}"
        job.update!(finished_at: Time.current) # Mark as finished even if failed
      end
    else
      sleep(0.1) # Poll every 100ms
    end
  end
end

# Handle graceful shutdown
trap("INT") do
  puts "\nShutting down SolidQueue server..."
  exit
end

trap("TERM") do
  puts "\nShutting down SolidQueue server..."
  exit
end

# Start processing
process_jobs