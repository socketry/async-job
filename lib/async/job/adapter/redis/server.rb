require_relative 'delayed_queue'
require_relative 'processing_queue'
require_relative 'ready_queue'

module Async
	module Job
		module Adapter
			module Redis
				class Server
					def initialize(client, prefix)
						@client = client
						@prefix = prefix
						
						@delayed_queue = DelayedQueue.new(@client, "#{@prefix}:delayed")
						@processing_queue = ProcessingQueue.new(@client, "#{@prefix}:processing")
						@ready_queue = ReadyQueue.new(@client, "#{@prefix}:ready")
					end
					
					def enqueue(job)
						if job.perform_at
							@delayed_queue.push(job)
						else
							@ready_queue.push(job)
						end
					end
					
					def each
						id = @ready_queue.move(@processing_queue.key)
						
						
					end
				end
			end