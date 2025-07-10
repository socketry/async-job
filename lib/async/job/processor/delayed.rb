# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative "generic"

require "console/event/failure"

module Async
	module Job
		module Processor
			# Add a small processing delay to each job.
			class Delayed < Generic
				def initialize(delegate, delay: 0.1)
					super(delegate)
					
					@delay = delay
				end
				
				def call(job)
					sleep(@delay)
					
					super
				end
			end
		end
	end
end
