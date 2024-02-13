
module Async
	module Job
		class Queue
			def initialize
			end
			
			def << job
			end
			
			def pop
			end
		end
	end
end

def invoke(*args, **options)
	invoke_queue = listen_queue

	push(actor_queue, [block_given? ? :invoke_with_block : :invoke, args, options, invoke_queue])

	while message = pop(invoke_queue)
		name, *args = message
		
		if name == :yield
			yield *args
		elsif name == :return
			return *args
		elsif name == :raise
			raise *args
		end
	end
end

def run
	while message = pop(actor_queue)
		name, *args = 

