# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require "async/queue"

module Async
	module Job
		# Represents a job buffer that stores and manages job execution.
		# The buffer acts as an intermediary between job producers and consumers,
		# providing a thread-safe queue for job storage and optional delegation.
		class Buffer
			# Initialize a new job buffer.
			# @parameter delegate [Object | nil] An optional delegate object that will receive job events.
			def initialize(delegate = nil)
				@jobs = Async::Queue.new
				@delegate = delegate
			end
			
			# Check if the buffer contains any pending jobs.
			# @returns [Boolean] True if the buffer is empty, false otherwise.
			def empty?
				@jobs.empty?
			end
			
			# @attribute [Async::Queue] The internal queue containing pending jobs.
			attr :jobs
			
			# Add a job to the buffer and optionally delegate to the configured delegate.
			# @parameter job [Object] The job to be added to the buffer.
			def call(job)
				@jobs.enqueue(job)
				@delegate&.call(job)
			end
			
			# Remove and return the next job from the buffer.
			# @returns [Object | nil] The next job from the buffer, or nil if empty.
			def pop
				@jobs.dequeue
			end
			
			# Start the buffer's delegate if one is configured.
			def start
				@delegate&.start
			end
			
			# Stop the buffer's delegate if one is configured.
			def stop
				@delegate&.stop
			end
		end
	end
end
