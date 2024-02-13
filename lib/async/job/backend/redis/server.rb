# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'delayed_queue'
require_relative 'jobs'
require_relative 'processing_state'
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
						
						@jobs = Jobs.new(@client, "#{@prefix}:jobs")
						
						@delayed_queue = DelayedQueue.new(@client, "#{@prefix}:delayed")
						@ready_queue = ReadyQueue.new(@client, "#{@prefix}:ready")
						
						@processing_state = ProcessingState.new(@client, "#{@prefix}:processing", @id)
					end
					
					def start
						@delayed_queue.start(@ready_queue)
						@processing_state.start(@ready_queue)
						@ready_queue.start(@processing_state)
					end
					
					def enqueue(job)
						if perform_at = job.perform_at and perform_at > Time.now.to_f
							# If the job is delayed, add it to the delayed queue:
							@delayed_queue.add(job, @jobs)
						else
							# If the job is ready to be processed now, add it to the ready queue:
							@ready_queue.add(job, @jobs)
						end
					end
				end
			end
		end
	end
end
