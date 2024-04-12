# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'redis/server'
require 'async/redis/client'

module Async
	module Job
		module Backend
			module Redis
				def self.new(delegate, endpoint: Async::Redis.local_endpoint, client_class: Async::Redis::Client, **options)
					client = client_class.new(endpoint)
					return Server.new(delegate, client, **options)
				end
			end
		end
	end
end
