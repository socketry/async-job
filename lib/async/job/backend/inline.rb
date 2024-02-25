# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'inline/server'

module Async
	module Job
		module Backend
			module Inline
				def self.new(handler)
					return Server.new(handler)
				end
			end
		end
	end
end
