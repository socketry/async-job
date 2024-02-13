module Async
	module Job
		module Adapter
			module Redis
				class Processing
					FETCH = <<~LUA
						local id = redis.call('BRPOP', KEYS[1])
						local job = redis.call('HGET', KEYS[2], id)
						return job
					LUA
					
					def initialize(client, key)
						@client = client
						@key = key
						
						@fetch = @client.script(:load, FETCH)
					end
					
					attr :key
					
					def pop(jobs_key)
						@client.evalsha(@fetch, 2, @key, jobs)
					end
				end
			end
		end
	end
end
