# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

require "active_job"
require "async/job/adapter/active_job"

class AsyncJobBenchmarkJob < ActiveJob::Base
	self.queue_adapter = :async_job
	queue_as :default
	
	def perform(index)
		PERFORMANCE_LOG.write "{index: #{index}, start_time: #{Process.clock_gettime(Process::CLOCK_MONOTONIC)}}\n"
		
		sleep(0.001)
		
		PERFORMANCE_LOG.write "{index: #{index}, end_time: #{Process.clock_gettime(Process::CLOCK_MONOTONIC)}}\n"
		PERFORMANCE_LOG.flush
	end
end
