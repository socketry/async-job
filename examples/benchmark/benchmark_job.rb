# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

require "active_job"

class BenchmarkJob < ActiveJob::Base
	def perform
		sleep(0.001)
		puts "Performed at: #{Process.clock_gettime(Process::CLOCK_MONOTONIC)}"
	end
end
