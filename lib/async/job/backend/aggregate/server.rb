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
					end
					
					def run(task)
						while true
							while @pending.empty?
								@ready.wait
							end
							
							task.defer_stop do
								# Swap the buffers:
								@pending, @processing = @processing, @pending
								
								flush(@processing)
							end
						end
					end
					
					def start!(parent: Async::Task.current)
						return if @task
						
						# We are creating a task:
						@task = true
						
						parent.async(transient: true) do |task|
							@task = task
							
							run(task)
						ensure
							# Ensure that all jobs are flushed before we exit:
							flush(@pending) if @pending.any?
							flush(@processing) if @processing.any?
							@task = nil
						end
					end
					
					# Latenc of this is low.
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
