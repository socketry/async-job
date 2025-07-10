# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

require_relative "../coder"
require_relative "generic"

require "async/idler"

module Async
	module Job
		module Processor
			# Represents an inline processor that executes jobs asynchronously using Async::Idler.
			# This processor handles job scheduling and executes jobs in the background,
			# providing a simple way to process jobs without external dependencies.
			class Inline < Generic
				# Initialize a new inline processor.
				# @parameter delegate [Object] The delegate object that will handle job execution.
				# @option parent [Async::Idler] The parent idler for managing async tasks (defaults to a new Async::Idler).
				def initialize(delegate, parent: nil)
					super(delegate)
					
					@parent = parent || Async::Idler.new
				end
				
				# Process a job asynchronously with optional scheduling.
				# If the job has a scheduled_at time, the processor will wait until that time before execution.
				# @parameter job [Hash] The job data containing execution details.
				def call(job)
					scheduled_at = Coder::Time(job["scheduled_at"])
					
					@parent.async do
						if scheduled_at
							sleep(scheduled_at - Time.now)
						end
						
						@delegate.call(job)
					rescue => error
						Console.error(self, error)
					end
				end
				
				# Start the processor by delegating to the configured delegate.
				def start
					@delegate.start
				end
				
				# Stop the processor by delegating to the configured delegate.
				def stop
					@delegate.stop
				end
			end
		end
	end
end
