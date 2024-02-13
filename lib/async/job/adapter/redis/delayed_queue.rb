module Async
	module Job
		module Adapter
			module Redis
				class DelayedQueue
					MOVE = <<~LUA
						local jobs = redis.call('ZRANGEBYSCORE', KEYS[1], 0, ARGV[1])
						redis.call('ZREMRANGEBYSCORE', KEYS[1], 0, ARGV[1])
						redis.call('LPUSH', KEYS[2], jobs)
					LUA
					
					def initialize(client, key)
						@client = client
						@key = key
						
						@move = @client.script(:load, MOVE)
					end
					
					attr :key
					
					def push(job)
						@client.zadd(@key, job.perform_at.to_f, job)
					end
					
					def move(destination:, now: Time.now.to_f)
						@client.evalsha(@move, 2, @key, destination, now)
					end
				end
			end
		end
	end
end