require_relative 'redis/server'

module Async
	module Job
		module Backend
			module Redis
				def self.new(**options)
					endpoint = options.fetch(:endpoint) {Async::Redis.local_endpoint}
					prefix = options.fetch(:prefix) {"async:job"}
					
					client = Async::Redis::Client.new(endpoint)
					
					return Async::Job::Backend::Redis::Server.new(client, prefix)
				end
			end
		end
	end
end
