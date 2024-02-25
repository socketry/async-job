# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'redis/server'
require 'async/redis/client'

module Async
	module Job
		module Backend
			module Redis
				def self.new(handler, endpoint: Async::Redis.local_endpoint, **options)
					client = Async::Redis::Client.new(endpoint)
					return Server.new(handler, client, **options)
				end
			end
		end
	end
end
