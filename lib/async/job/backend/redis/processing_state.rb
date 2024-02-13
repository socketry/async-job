# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Job
		module Backend
			module Redis
				class ProcessingState
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
					
					def initialize(client, key, id)
						@client = client
						@key = key
						@id = id
						
						@pending_key = "#{@key}:#{@id}:pending"
						@heartbeat_key = "#{@key}:#{@id}"
						
						@requeue = @client.script(:load, REQUEUE)
					end
					
					attr :key
					
					def fetch(ready_queue)
						@client.brpoplpush(ready_queue.key, @pending_key, 0)
					end
					
					def complete(id)
						@client.lrem(@pending_key, 1, id)
					end
					
					def start(ready_queue, delay: 5, factor: 2, parent: Async::Task.current)
						heartbeat_key = "#{@key}:#{@id}"
						
						start_time = Time.now.to_f
						
						parent.async do
							while true
								uptime = (Time.now.to_f - start_time).round(2)
								@client.set(heartbeat_key, JSON.dump(uptime: uptime), seconds: delay*factor)
								
								# Requeue any jobs that have been abandoned:
								count = @client.evalsha(@requeue, 2, @key, ready_queue.key)
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
