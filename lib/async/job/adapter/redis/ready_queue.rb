module Async
	module Job
		module Adapter
			module Redis
				class ReadyQueue
					def initialize(client, key)
						@client = client
						@key = key
					end
					
					attr :key
					
					def push(*jobs)
						@client.lpush(@key, jobs)
					end
					
					def move(destination)
						@client.brpoplpush(@key, destination, 0)
					end
				end
			end
		end
	end
end
