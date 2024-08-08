# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

module Async
	module Job
		class Queue
			def initialize(client, server, delegate)
				@client = client
				@server = server
				@delegate = delegate
			end
			
			attr :client
			attr :server
			attr :delegate
			
			def call(...)
				@client.call(...)
			end
			
			def start
				@server.start
			end
			
			def stop
				@server.stop
			end
		end
	end
end
