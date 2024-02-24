require_relative 'backend/redis'

module Async
	module Job
		module Backend
			def self.new(backend: Async::Job::Backend::Redis, **options)
				backend.new(**options)
			end
		end
	end
end
