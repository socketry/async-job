# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require "json"

module Async
	module Job
		module Coder
			DEFAULT = JSON
			
			# Type-cast for time values. See <https://bugs.ruby-lang.org/issues/20298> for background.
			# @parameter value [Time || Integer || String || nil]
			def self.Time(value)
				case value
				when ::Time
					value
				when Integer
					::Time.at(value)
				when String
					::Time.new(value)
				when nil
					nil
				else
					value.to_time
				end
			end
		end
	end
end
