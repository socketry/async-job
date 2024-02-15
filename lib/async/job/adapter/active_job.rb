# frozen_string_literal: true

module Async
	module Job
		module Adapter
			class ActiveJob
				def initialize(server)
					@server = server
				end
				
				def enqueue(job) # :nodoc:
					@server.enqueue(job.serialize)
				end
				
				def enqueue_at(job, timestamp)
					@server.schedule(job.serialize, timestamp)
				end
				
				def perform(id, job)
					@server.each do |id, job|
						Base.execute(job)
					end
				end
			end
		end
	end
end
