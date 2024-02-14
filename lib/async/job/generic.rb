module Async
	module Job
		class Generic
			def self.enqueue(...)
				self.new(...).enqueue
			
			def initialize(id, perform_at: nil)
				@id = id
				@perform_at = perform_at
			end
			
			attr :id
			attr :perform_at
			
			def serialize
				raise NotImplementedError
			end
			
			def call
				raise NotImplementedError
			end
		end
	end
end


server.enqueue(job)
	-> job.serialize

Server.enqueue(job)