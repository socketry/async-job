require 'async/queue'

module Async
	module Job
		class Buffer
			def initialize
				@jobs = Async::Queue.new
			end
			
			attr :jobs
			
			def call(job)
				@jobs.enqueue(job)
			end
			
			def pop
				@jobs.dequeue
			end
		end
	end
end
