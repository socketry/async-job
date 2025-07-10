# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative "generic"

require "console/event/failure"

module Async
	module Job
		module Processor
			# Represents an aggregate processor that batches jobs for efficient processing.
			# This processor collects jobs in a buffer and processes them in batches,
			# reducing the overhead of individual job processing and improving throughput.
			class Aggregate < Generic
				# Initialize a new aggregate processor.
				# @parameter delegate [Object] The delegate object that will handle job execution.
				# @option parent [Async::Task] The parent task for managing the background processing (defaults to Async::Task.current).
				def initialize(delegate, parent: nil)
					super(delegate)
					
					@task = nil
					@ready = Async::Condition.new
					
					@pending = Array.new
					@processing = Array.new
				end
				
				# Process a batch of jobs by delegating each job to the configured delegate.
				# @parameter jobs [Array] The array of jobs to process.
				def flush(jobs)
					while job = jobs.shift
						@delegate.call(job)
					end
				rescue => error
					Console::Event::Failure.for(error).emit(self, "Could not flush #{jobs.size} jobs.")
				end
				
				# Run the background processing loop that continuously processes job batches.
				# @parameter task [Async::Task] The task that manages the background processing.
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
				# @option parent [Async::Task] The parent task for the background processing (defaults to Async::Task.current).
				# @returns [Boolean] True if the task was started, false if it was already running.
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
				# Start the background processing task if it is not already running.
				# @parameter job [Object] The job to be enqueued.
				def call(job)
					@pending << job
					
					start! or @ready.signal
				end
				
				# Start the processor and the background processing task.
				def start
					super
					
					self.start!
				end
				
				# Stop the processor and the background processing task.
				def stop
					@task&.stop
					
					super
				end
			end
		end
	end
end
