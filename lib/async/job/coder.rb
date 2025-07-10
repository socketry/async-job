# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require "json"

module Async
	module Job
		# A collection of coders for job serialization and deserialization.
		# Provides different encoding strategies for job data, including JSON, Marshal, and MessagePack.
		module Coder
			# @attribute [Class] The default coder class to use for job serialization.
			DEFAULT = JSON
			
			# Type-cast for time values. See <https://bugs.ruby-lang.org/issues/20298> for background.
			# @parameter value [Time | Integer | String | nil]
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
