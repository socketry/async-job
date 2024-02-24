# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

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
