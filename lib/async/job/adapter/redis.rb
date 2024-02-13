require 'async/redis'

module Async
	module Job
		module Queue
			class RedisList
				def initialize(client, key)
					@client = client
					@key = key
				end
				
				def push(*jobs)
					@client.lpush(@key, jobs)
				end
				
				def pop()
					@client.brpop(@key)
				end
			end
		end
	end
end


jobs = hash[id: job, id: job, id: job]
waiting = [id, id, id]
queued = sorted_set[timestamp: id, timestamp: id, timestamp: id]
