# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Job
		module Backend
			module Redis
				class Jobs
					def initialize(client, key)
						@client = client
						@key = key
					end
					
					attr :key
					
					def add(job)
						@client.hset(@key, job.id, job)
					end
				end
			end
		end
	end
end
