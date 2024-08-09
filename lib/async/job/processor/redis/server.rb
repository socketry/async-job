# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'delayed_jobs'
require_relative 'job_store'
require_relative 'processing_list'
require_relative 'ready_list'
require_relative '../../coder'
require_relative '../generic'

require 'securerandom'
require 'async/idler'

module Async
	module Job
		module Processor
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
						@delayed_jobs = DelayedJobs.new(@client, "#{@prefix}:delayed")
						@ready_list = ReadyList.new(@client, "#{@prefix}:ready")
						@processing_list = ProcessingList.new(@client, "#{@prefix}:processing", @id, @ready_list, @job_store)
						
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
						
						# Start the delayed processor, which will move jobs to the ready processor when they are ready:
						@delayed_jobs.start(@ready_list, resolution: @resolution)
						
						# Start the processing processor, which will move jobs to the ready processor when they are abandoned:
						@processing_list.start
						
						self.start!
					end
					
					def stop
						@task&.stop
						
						super
					end
					
					def call(job)
						scheduled_at = Coder::Time(job["scheduled_at"])
						
						if scheduled_at
							@delayed_jobs.add(@coder.dump(job), scheduled_at, @job_store)
						else
							@ready_list.add(@coder.dump(job), @job_store)
						end
					end
					
					protected
					
					def dequeue(parent)
						_id = @processing_list.fetch
						
						parent.async do
							id = _id; _id = nil
							
							job = @coder.load(@job_store.get(id))
							@delegate.call(job)
							@processing_list.complete(id)
						rescue => error
							Console::Event::Failure.for(error).emit(self, "Job failed with error!", id: id)
							@processing_list.fail(id)
						end
					ensure
						@processing_list.retry(_id) if _id
					end
				end
			end
		end
	end
end
