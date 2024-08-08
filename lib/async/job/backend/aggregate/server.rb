# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative '../generic'

require 'console/event/failure'

module Async
	module Job
		module Backend
			module Aggregate
				class Server < Generic
					def initialize(delegate, parent: nil)
						super(delegate)
						
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
					
					# Start the background processing task if it is not already running.
					#
					# @return [Boolean] true if the task was started, false if it was already running.
					protected def start!(parent: Async::Task.current)
						return false if @task
						
						# We are creating a task:
						@task = true
						
						parent.async(transient: true, annotation: self.class.name) do |task|
							@task = task
							
							run(task)
						ensure
							# Ensure that all jobs are flushed before we exit:
							flush(@processing) if @processing.any?
							flush(@pending) if @pending.any?
							@task = nil
						end
						
						return true
					end
					
					# Enqueue a job into the pending buffer.
					#
					# Start the background processing task if it is not already running.
					def call(job)
						@pending << job
						
						start! or @ready.signal
					end
					
					def start
						super
						
						self.start!
					end
					
					def stop
						@task&.stop
						
						super
					end
				end
			end
		end
	end
end
