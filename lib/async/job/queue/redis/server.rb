# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'delayed_queue'
require_relative 'job_store'
require_relative 'processing_queue'
require_relative 'ready_queue'
require_relative '../../coder'
require_relative '../generic'

require 'securerandom'
require 'async/idler'

module Async
	module Job
		module Queue
			module Redis
				class Server < Generic
					def initialize(delegate, client, prefix: 'async-job', coder: Coder::DEFAULT, resolution: 10, parent: nil)
						super(delegate)
						
						@id = SecureRandom.uuid
						@client = client
						@prefix = prefix
						@coder = coder
						@resolution = resolution
						
						@job_store = JobStore.new(@client, "#{@prefix}:jobs")
						
						@delayed_queue = DelayedQueue.new(@client, "#{@prefix}:delayed")
						@ready_queue = ReadyQueue.new(@client, "#{@prefix}:ready")
						
						@processing_queue = ProcessingQueue.new(@client, "#{@prefix}:processing", @id, @ready_queue, @job_store)
						
						@parent = parent || Async::Idler.new
					end
					
					def start!
						return false if @task
						
						@task = true
						
						@parent.async(transient: true, annotation: self.class.name) do |task|
							@task = task
							
							while true
								self.dequeue(task)
							end
						ensure
							@task = nil
						end
					end
					
					def start
						super
						
						# Start the delayed queue, which will move jobs to the ready queue when they are ready:
						@delayed_queue.start(@ready_queue, resolution: @resolution)
						
						# Start the processing queue, which will move jobs to the ready queue when they are abandoned:
						@processing_queue.start
						
						self.start!
					end
					
					def stop
						@task&.stop
						
						super
					end
					
					def call(job)
						scheduled_at = Coder::Time(job["scheduled_at"])
						
						if scheduled_at
							@delayed_queue.add(@coder.dump(job), scheduled_at, @job_store)
						else
							@ready_queue.add(@coder.dump(job), @job_store)
						end
					end
					
					protected
					
					def dequeue(parent)
						_id = @processing_queue.fetch
						
						parent.async do
							id = _id; _id = nil
							
							job = @coder.load(@job_store.get(id))
							@delegate.call(job)
							@processing_queue.complete(id)
						rescue => error
							@processing_queue.retry(id)
							Console.error(self, error)
						end
					ensure
						@processing_queue.retry(_id) if _id
					end
				end
			end
		end
	end
end
