#!/usr/bin/env ruby
# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

require_relative "config/environment"

def benchmark_async_job(job_count = 10_000)
	puts "Benchmarking async-job with #{job_count} jobs..."
	
	start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
	
	Sync do
		job_count.times do |index|
			AsyncJobBenchmarkJob.perform_later(index)
		end
	end
	
	end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
	
	puts "Async-job results:"
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

benchmark_async_job(job_count)
