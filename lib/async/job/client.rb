
module Async
	module Job
		class WorkQueue
			def initialize(enqueue_jobs = true)
				@enqueue_jobs = enqueue_jobs
				
				@jobs = []
			end
			
			attr :jobs
			
			def enqueue_jobs?
				@enqueue_jobs
			end
			
			def include?(*args)
				@jobs.include?(*args)
			end
			
			def << job
				@jobs << job
				
				if enqueue_jobs?
					Resque.enqueue(*job)
				end
			end
			
			def last
				@jobs.last
			end
			
			def empty?
				@jobs.empty?
			end
			
			module Client
				def work_queue
					@work_queue ||= WorkQueue.new(self.class.connection_config[:enqueue_jobs])
				end
			end
		end
	end
end
