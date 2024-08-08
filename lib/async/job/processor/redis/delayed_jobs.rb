# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Job
		module Processor
			module Redis
				class DelayedJobs
					ADD = <<~LUA
						redis.call('HSET', KEYS[1], ARGV[1], ARGV[2])
						redis.call('ZADD', KEYS[2], ARGV[3], ARGV[1])
					LUA
					
					MOVE = <<~LUA
						local jobs = redis.call('ZRANGEBYSCORE', KEYS[1], 0, ARGV[1])
						redis.call('ZREMRANGEBYSCORE', KEYS[1], 0, ARGV[1])
						if #jobs > 0 then
							redis.call('LPUSH', KEYS[2], unpack(jobs))
						end
						return #jobs
					LUA
					
					def initialize(client, key)
						@client = client
						@key = key
						
						@add = @client.script(:load, ADD)
						@move = @client.script(:load, MOVE)
					end
					
					def start(ready_list, resolution: 10, parent: Async::Task.current)
						parent.async do
							while true
								count = move(destination: ready_list.key)
								
								if count > 0
									Console.debug(self, "Moved #{count} delayed jobs to ready list.")
								end
								
								sleep(resolution)
							end
						end
					end
					
					attr :key
					
					def add(job, timestamp, job_store)
						id = SecureRandom.uuid
						
						@client.evalsha(@add, 2, job_store.key, @key, id, job, timestamp.to_f)
						
						return id
					end
					
					def move(destination:, now: Time.now.to_i)
						@client.evalsha(@move, 2, @key, destination, now)
					end
				end
			end
		end
	end
end
