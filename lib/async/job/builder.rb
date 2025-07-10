# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative "queue"

module Async
	module Job
		class Builder
			def self.build(delegate = nil, &block)
				builder = self.new(delegate)
				
				builder.instance_eval(&block)
				
				return builder.build
			end
			
			# @parameter delegate [Object] The initial delegate that will be wrapped by the queue.
			def initialize(delegate = nil)
				# The client side middleware, in the order they should be applied to a job:
				@enqueue = []
				
				# The server side middleware, in the order they should be applied to a job:
				@dequeue = []
				
				# The output delegate, if any:
				@delegate = delegate
			end
			
			def enqueue(middleware, ...)
				@enqueue << ->(delegate){middleware.new(delegate, ...)}
			end
			
			def dequeue(middleware, ...)
				@dequeue << ->(delegate){middleware.new(delegate, ...)}
			end
			
			def delegate(delegate)
				@delegate = delegate
			end
			
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
