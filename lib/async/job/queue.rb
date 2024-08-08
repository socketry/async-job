# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'queue/inline'

module Async
	module Job
		module Queue
			def self.new(queue: Inline, **options)
				queue.new(**options)
			end
		end
	end
end
