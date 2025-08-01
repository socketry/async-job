# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

require "active_job"

class SidekiqBenchmarkJob < ActiveJob::Base
	# Use sidekiq adapter specifically for this job
	self.queue_adapter = :sidekiq
	queue_as :sidekiq_default
	
	def perform(index)
		PERFORMANCE_LOG.write "{index: #{index}, start_time: #{Process.clock_gettime(Process::CLOCK_MONOTONIC)}}\n"
		
		sleep(0.001)
		
		PERFORMANCE_LOG.write "{index: #{index}, end_time: #{Process.clock_gettime(Process::CLOCK_MONOTONIC)}}\n"
		PERFORMANCE_LOG.flush
	end
end
