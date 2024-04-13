# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'redis/server'
require 'async/redis/client'

module Async
	module Job
		module Backend
			module Redis
				# A simple server that processes jobs from a Redis backend.
				#
				# @parameter delegate [Object] The object that will be called with the job data.
				# @parameter endpoint [Async::IO::Endpoint] The Redis endpoint to connect to.
				# @parameter protocol [Async::Redis::Protocol] The Redis protocol to use.
				# @parameter options [Hash] Additional options passed to the server.
				def self.new(delegate, endpoint: Async::Redis.local_endpoint, protocol: nil, **options)
					client_options = {protocol: protocol}.compact
					
					client = Async::Redis::Client.new(endpoint, **client_options)
					return Server.new(delegate, client, **options)
				end
			end
		end
	end
end
