# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

require_relative "queue"

module Async
	module Job
		# Represents a builder for creating job processing pipelines.
		# The builder allows you to configure middleware for both enqueue and dequeue operations,
		# creating a complete job processing system with client and server components.
		class Builder
			# Build a job processing pipeline using the provided delegate and configuration block.
			# @parameter delegate [Object | nil] The delegate that will execute the jobs.
			# @yields {|builder| ...} The builder instance for configuration.
			# @returns [Async::Job::Queue] A configured job queue with client and server components.
			def self.build(delegate = nil, &block)
				builder = self.new(delegate)
				
				builder.instance_eval(&block)
				
				return builder.build
			end
			
			# Initialize a new job builder.
			# @parameter delegate [Object] The initial delegate that will be wrapped by the queue.
			def initialize(delegate = nil)
				# The client side middleware, in the order they should be applied to a job:
				@enqueue = []
				
				# The server side middleware, in the order they should be applied to a job:
				@dequeue = []
				
				# The output delegate, if any:
				@delegate = delegate
			end
			
			# Add middleware to the enqueue pipeline.
			# @parameter middleware [Class] The middleware class to add.
			def enqueue(middleware, ...)
				@enqueue << ->(delegate){middleware.new(delegate, ...)}

				return self
			end
			
			# Add middleware to the dequeue pipeline.
			# @parameter middleware [Class] The middleware class to add.
			def dequeue(middleware, ...)
				@dequeue << ->(delegate){middleware.new(delegate, ...)}

				return self
			end
			
			# Set the delegate that will execute the jobs.
			# @parameter delegate [Object] The delegate object.
			def delegate(delegate)
				@delegate = delegate

				return self
			end
			
			# Build the final job processing pipeline.
			# @parameter delegate [Object] The delegate to use (defaults to the instance delegate).
			# @returns [Async::Job::Queue] A configured job queue.
			def build(delegate = @delegate)
				# We then wrap the delegate with the middleware in reverse order:
				@dequeue.reverse_each do |middleware|
					delegate = middleware.call(delegate)
				end
				
				client = server = delegate
				
				# We now construct the queue producer:
				@enqueue.reverse_each do |middleware|
					client = middleware.call(client)
				end
				
				return Queue.new(client, server, @delegate)
			end
		end
	end
end
