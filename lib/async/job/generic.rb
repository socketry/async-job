# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Job
		# Represents a generic job interface that defines the minimum required structure for jobs.
		# This class serves as a base for implementing specific job types and provides
		# common functionality for job identification and scheduling.
		class Generic
			# Create and enqueue a new job with the given parameters.
			# @parameter ... [Object] Parameters to pass to the job constructor.
			# @returns [Async::Job::Generic] The created and enqueued job.
			def self.enqueue(...)
				self.new(...).enqueue
			end
			
			# Initialize a new generic job.
			# @parameter id [Object] The unique identifier for this job.
			# @option scheduled_at [Time | nil] The time when this job should be executed.
			def initialize(id, scheduled_at: nil)
				@id = id
				@scheduled_at = scheduled_at
			end
			
			# @attribute [Object] The unique identifier for this job.
			attr :id
			# @attribute [Time | nil] The scheduled execution time for this job.
			attr :scheduled_at
			
			# Serialize the job for storage or transmission.
			# This method must be implemented by subclasses.
			# @raises [NotImplementedError] Always raised, must be implemented by subclasses.
			def serialize
				raise NotImplementedError
			end
			
			# Execute the job.
			# This method must be implemented by subclasses.
			# @raises [NotImplementedError] Always raised, must be implemented by subclasses.
			def call
				raise NotImplementedError
			end
		end
	end
end
