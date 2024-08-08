# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Job
		module Processor
			module Redis
				class JobStore
					def initialize(client, key)
						@client = client
						@key = key
					end
					
					attr :key
					
					def get(id)
						@client.hget(@key, id)
					end
				end
			end
		end
	end
end
