# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Job
		module Processor
			module Redis
				class ReadyList
					ADD = <<~LUA
						redis.call('HSET', KEYS[1], ARGV[1], ARGV[2])
						redis.call('LPUSH', KEYS[2], ARGV[1])
					LUA
					
					def initialize(client, key)
						@client = client
						@key = key
						
						@add = @client.script(:load, ADD)
					end
					
					attr :key
					
					def add(job, job_store)
						id = SecureRandom.uuid
						
						@client.evalsha(@add, 2, job_store.key, @key, id, job)
						
						return id
					end
				end
			end
		end
	end
end
