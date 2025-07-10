# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

module Async
	module Job
		module Processor
			# Represents a generic processor that delegates job execution to a provided delegate.
			# This processor acts as a simple wrapper around any object that responds to call, start, and stop methods.
			class Generic
				# Initialize a new generic processor.
				# @parameter delegate [Object] The delegate object that will handle job execution.
				def initialize(delegate)
					@delegate = delegate
				end
				
				# Process a job by delegating to the configured delegate.
				# @parameter job [Object] The job to be processed.
				def call(job)
					@delegate.call(job)
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
