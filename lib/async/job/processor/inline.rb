# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require_relative 'inline/server'

module Async
	module Job
		module Processor
			module Inline
				def self.new(delegate)
					return Server.new(delegate)
				end
			end
		end
	end
end
