# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'delayed_queue'
require_relative 'job_store'
require_relative 'processing_queue'
require_relative 'ready_queue'

require 'securerandom'

module Async
	module Job
		module Backend
			module Redis
				class Server
					def initialize(client, prefix)
						@id = SecureRandom.uuid
						@client = client
						@prefix = prefix
						
						@job_store = JobStore.new(@client, "#{@prefix}:jobs")
						
						@delayed_queue = DelayedQueue.new(@client, "#{@prefix}:delayed")
						@ready_queue = ReadyQueue.new(@client, "#{@prefix}:ready")
						
						@processing_queue = ProcessingQueue.new(@client, "#{@prefix}:processing", @id, @ready_queue, @job_store)
					end
					
					def start
						# Start the delayed queue, which will move jobs to the ready queue when they are ready:
						@delayed_queue.start(@ready_queue)
						
						# Start the processing queue, which will move jobs to the ready queue when they are abandoned:
						@processing_queue.start
					end
					
					def enqueue(job)
						if perform_at = job.perform_at and perform_at > Time.now.to_f
							# If the job is delayed, add it to the delayed queue:
							@delayed_queue.add(job, @job_store)
						else
							# If the job is ready to be processed now, add it to the ready queue:
							@ready_queue.add(job, @job_store)
						end
					end
					
					def each(&block)
						while id = @processing_queue.fetch
							begin
								job = @job_store.get(id)
								yield id, job
								@processing_queue.complete(id)
							rescue => error
								@processing_queue.retry(id)
								raise
							end
						end
					end
				end
			end
		end
	end
end
