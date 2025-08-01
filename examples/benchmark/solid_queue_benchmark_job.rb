# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

class SolidQueueBenchmarkJob
	# Simple plain Ruby job class (no ActiveJob inheritance)
	def perform
		sleep(0.001)
		puts "[solid_queue] Job performed at: #{Process.clock_gettime(Process::CLOCK_MONOTONIC)}"
	end
end