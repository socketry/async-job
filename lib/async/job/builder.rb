# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Job
		class Builder
			Pipeline = Struct.new(:producer, :consumer, :delegate)
			
			def self.build(delegate = nil, &block)
				builder = self.new(delegate)
				
				builder.instance_eval(&block)
				
				return builder.build
			end
			
			def initialize(delegate = nil)
				@enqueue = []
				@dequeue = []
				@delegate = delegate
				
				@queue = nil
			end
			
			def enqueue(middleware)
				@enqueue << middleware
			end
			
			def queue(queue, *arguments, **options)
				# The delegate is the output side of the queue, e.g. a Queuedelegate or similar wrapper.
				# The queue itself is instantiated with the delegate.
				@queue = ->(delegate){queue.new(delegate, *arguments, **options)}
			end
			
			def dequeue(middleware)
				@dequeue << middleware
			end
			
			def delegate(delegate)
				@delegate = delegate
			end
			
			def build(&block)
				# To construct the queue, we need the delegate.
				delegate = @delegate
				
				# We then wrap the delegate with the middleware in reverse order:
				@dequeue.reverse_each do |middleware|
					delegate = middleware.new(delegate)
				end
				
				# We can now construct the queue with the delegate:
				producer = consumer = @queue.call(delegate)
				
				# We now construct the queue producer:
				@enqueue.reverse_each do |middleware|
					producer = middleware.new(queue)
				end
				
				if block_given?
					producer = yield(producer)
				end
				
				return Pipeline.new(producer, consumer, @delegate)
			end
		end
	end
end
