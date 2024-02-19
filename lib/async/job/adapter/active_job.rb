# frozen_string_literal: true

module Async
	module Job
		module Adapter
			class ActiveJob
				def initialize(server, coder = JSON)
					@server = server
					@coder = coder
				end
				
				def enqueue(job)
					Console.info(self, "Enqueueing job...", id: job.job_id)
					@server.enqueue(@coder.dump(job.serialize))
				end
				
				def enqueue_at(job, timestamp)
					Console.info(self, "Enqueueing job at...", id: job.job_id, timestamp: timestamp)
					@server.schedule(@coder.dump(job.serialize), timestamp)
				end
				
				def start
					Async do
						@server.start
						
						@server.each do |id, data|
							job = @coder.parse(data)
							::ActiveJob::Base.execute(job)
						end
					end
				end
			end
		end
	end
end
