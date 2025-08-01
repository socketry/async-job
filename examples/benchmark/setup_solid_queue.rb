#!/usr/bin/env ruby
# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

# Setup script for SolidQueue database

require "active_record"
require "logger"

# Connect to SQLite database
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/solid_queue.sqlite3'
)

ActiveRecord::Base.logger = Logger.new(STDOUT)

# Create SolidQueue tables
ActiveRecord::Schema.define do
  # Core job storage table
  create_table :solid_queue_jobs, if_not_exists: true do |t|
    t.string :job_class, null: false
    t.text :job_args, null: false
    t.string :queue_name, null: false
    t.integer :priority, default: 0, null: false
    t.timestamp :scheduled_at
    t.timestamp :finished_at
    
    t.timestamps null: false
    
    t.index [:queue_name, :priority, :scheduled_at], name: "index_solid_queue_jobs_for_polling"
    t.index [:scheduled_at], name: "index_solid_queue_jobs_on_scheduled_at"
    t.index [:finished_at], name: "index_solid_queue_jobs_on_finished_at"
  end
  
  # Process tracking table
  create_table :solid_queue_processes, if_not_exists: true do |t|
    t.string :name, null: false
    t.string :hostname, null: false
    t.integer :pid, null: false
    t.timestamp :last_heartbeat_at, null: false
    
    t.timestamps null: false
    
    t.index [:name], unique: true
    t.index [:last_heartbeat_at]
  end
  
  # Failed jobs table
  create_table :solid_queue_failed_executions, if_not_exists: true do |t|
    t.references :job, null: false, foreign_key: { to_table: :solid_queue_jobs }
    t.text :exception_class
    t.text :exception_message
    t.text :backtrace
    
    t.timestamps null: false
  end
end

puts "SolidQueue database tables created successfully!"
puts "Database: db/solid_queue.sqlite3"