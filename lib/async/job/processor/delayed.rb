# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative "generic"

require "console/event/failure"

module Async
	module Job
		module Processor
			# Represents a processor that adds a configurable delay before processing each job.
			# This processor is useful for rate limiting or adding artificial delays to job processing.
			class Delayed < Generic
				# Initialize a new delayed processor.
				# @parameter delegate [Object] The delegate object that will handle job execution.
				# @option delay [Float] The delay in seconds to add before processing each job (defaults to 0.1).
				def initialize(delegate, delay: 0.1)
					super(delegate)
					
					@delay = delay
				end
				
				# Process a job after the configured delay.
				# @parameter job [Object] The job to be processed.
				def call(job)
					sleep(@delay)
					
					super
				end
			end
		end
	end
end
