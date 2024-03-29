# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'async/queue'

module Async
	module Job
		class Buffer
			def initialize(delegate = nil)
				@jobs = Async::Queue.new
				@delegate = delegate
			end
			
			attr :jobs
			
			def call(job)
				@jobs.enqueue(job)
				@delegate&.call(job)
			end
			
			def pop
				@jobs.dequeue
			end
		end
	end
end
