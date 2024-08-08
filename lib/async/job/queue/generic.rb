# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Job
		module Queue
			class Generic
				def initialize(delegate = nil)
					@delegate = delegate
				end
				
				def call(job)
					@delegate.call(job)
				end
				
				def start
					@delegate.start
				end
				
				def stop
					@delegate.stop
				end
			end
		end
	end
end
