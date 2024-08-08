# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Job
		class Builder
			# A pipeline is a sequence of middleware that wraps a delegate. The client end of the pipeline is where jobs should be submitted. The server end of the middleware is where jobs are processed.
			Pipeline = Struct.new(:client, :server, :delegate)
			
			def self.build(delegate = nil, &block)
				builder = self.new(delegate)
				
				builder.instance_eval(&block)
				
				return builder.build
			end
			
			# @parameter delegate [Object] The initial delegate that will be wrapped by the queue.
			def initialize(delegate = nil)
				@enqueue = []
				@dequeue = []
				@delegate = delegate
				
				@queue = nil
			end
			
			def enqueue(middleware, ...)
				@enqueue << ->(delegate){middleware.new(delegate, ...)}
			end
			
			def queue(queue, ...)
				# The delegate is the output side of the queue, e.g. a Redis server delegate or similar wrapper.
				# The queue itself is instantiated with the delegate.
				@queue = ->(delegate){queue.new(delegate, ...)}
			end
			
			def dequeue(middleware, ...)
				@dequeue << ->(delegate){middleware.new(delegate, ...)}
			end
			
			def delegate(delegate)
				@delegate = delegate
			end
			
			def build(delegate = @delegate, &block)
				# We then wrap the delegate with the middleware in reverse order:
				@dequeue.reverse_each do |middleware|
					delegate = middleware.call(delegate)
				end
				
				# We can now construct the queue with the delegate:
				if @queue
					client = server = @queue.call(delegate)
				else
					client = server = delegate
				end
				
				# We now construct the queue producer:
				@enqueue.reverse_each do |middleware|
					client = middleware.call(client)
				end
				
				if block_given?
					client = yield(client) || client
				end
				
				return Pipeline.new(client, server, @delegate)
			end
		end
	end
end
