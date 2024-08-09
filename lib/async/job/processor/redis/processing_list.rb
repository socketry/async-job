# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Job
		module Processor
			module Redis
				class ProcessingList
					REQUEUE = <<~LUA
						local cursor = "0"
						local count = 0
						
						repeat
							-- Scan through all known server id -> job id mappings and requeue any jobs that have been abandoned:
							local result = redis.call('SCAN', cursor, 'MATCH', KEYS[1]..':*:pending')
							cursor = result[1]
							for _, pending_key in pairs(result[2]) do
								-- Check if the server is still active:
								local server_key = KEYS[1]..":"..pending_key:match("([^:]+):pending")
								local state = redis.call('GET', server_key)
								if state == false then
									while true do
										-- Requeue any pending jobs:
										local result = redis.call('RPOPLPUSH', pending_key, KEYS[2])
										
										if result == false then
											-- Delete the pending list:
											redis.call('DEL', pending_key)
											break
										end
										
										count = count + 1
									end
								end
							end
						until cursor == "0"
						
						return count
					LUA
					
					RETRY = <<~LUA
						redis.call('LREM', KEYS[1], 1, ARGV[1])
						redis.call('LPUSH', KEYS[2], ARGV[1])
					LUA
					
					COMPLETE = <<~LUA
						redis.call('LREM', KEYS[1], 1, ARGV[1])
						redis.call('HDEL', KEYS[2], ARGV[1])
					LUA
					
					def initialize(client, key, id, ready_list, job_store)
						@client = client
						@key = key
						@id = id
						
						@ready_list = ready_list
						@job_store = job_store
						
						@pending_key = "#{@key}:#{@id}:pending"
						@heartbeat_key = "#{@key}:#{@id}"
						
						@requeue = @client.script(:load, REQUEUE)
						@retry = @client.script(:load, RETRY)
						@complete = @client.script(:load, COMPLETE)
					end
					
					attr :key
					
					def fetch
						@client.brpoplpush(@ready_list.key, @pending_key, 0)
					end
					
					def complete(id)
						@client.evalsha(@complete, 2, @pending_key, @job_store.key, id)
					end
					
					def retry(id)
						Console.warn(self, "Retrying job: #{id}")
						@client.evalsha(@retry, 2, @pending_key, @ready_list.key, id)
					end
					
					def start(delay: 5, factor: 2, parent: Async::Task.current)
						heartbeat_key = "#{@key}:#{@id}"
						start_time = Time.now.to_f
						
						parent.async do
							while true
								uptime = (Time.now.to_f - start_time).round(2)
								@client.set(heartbeat_key, JSON.dump(uptime: uptime), seconds: delay*factor)
								
								# Requeue any jobs that have been abandoned:
								count = @client.evalsha(@requeue, 2, @key, @ready_list.key)
								if count > 0
									Console.warn(self, "Requeued #{count} abandoned jobs.")
								end
								
								sleep(delay)
							end
						end
					end
				end
			end
		end
	end
end
