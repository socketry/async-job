# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require 'console/event/failure'

module Async
	module Job
		module Backend
			module Aggregate
				class Server
					def initialize(delegate, parent: nil)
						@delegate = delegate
						
						@task = nil
						@ready = Async::Condition.new
						
						@pending = Array.new
						@processing = Array.new
					end
					
					def flush(jobs)
						while job = jobs.shift
							@delegate.call(job)
						end
					rescue => error
						Console::Event::Failure.for(error).emit(self, "Could not flush #{jobs.size} jobs.")
					end
					
					def run
						while true
							while @pending.empty?
								@ready.wait
							end
							
							# Swap the buffers:
							@pending, @processing = @processing, @pending
							
							flush(@processing)
						end
					end
					
					def start!(parent: Async::Task.current)
						@task ||= parent.async(transient: true) do
							run
						ensure
							# Ensure that all jobs are flushed before we exit:
							flush(@pending)
							flush(@processing)
						end
					end
					
					def call(job)
						start!
						
						@pending << job
						@ready.signal
					end
				end
			end
		end
	end
end
