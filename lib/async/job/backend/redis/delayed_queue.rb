# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Job
		module Backend
			module Redis
				class DelayedQueue
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
					LUA
					
					def initialize(client, key)
						@client = client
						@key = key
						
						@add = @client.script(:load, ADD)
						@move = @client.script(:load, MOVE)
					end
					
					def start(ready_queue, resolution: 10, parent: Async::Task.current)
						parent.async do
							while true
								move(destination: ready_queue.key)
								sleep(resolution)
							end
						end
					end
					
					attr :key
					
					def add(job, job_store)
						@client.evalsha(@add, 2, job_store.key, @key, job.id, job.serialize, job.perform_at.to_f)
					end
					
					def move(destination:, now: Time.now.to_i)
						@client.evalsha(@move, 2, @key, destination, now)
					end
				end
			end
		end
	end
end
