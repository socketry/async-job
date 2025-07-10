# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024, by Samuel Williams.

require "msgpack"

module Async
	module Job
		module Coder
			# Represents a coder that uses Ruby's Marshal for job serialization.
			# Marshal provides fast serialization but is Ruby-specific and not suitable
			# for cross-language job processing systems.
			class Marshal
				# Serialize a job object using Ruby's Marshal.
				# @parameter job [Object] The job object to serialize.
				# @returns [String] The serialized job data.
				def dump(job)
					::Marshal.dump(job)
				end
				
				# Deserialize job data using Ruby's Marshal.
				# @parameter data [String] The serialized job data.
				# @returns [Object] The deserialized job object.
				def load(data)
					::Marshal.load(data)
				end
				
				# @attribute [Async::Job::Coder::Marshal] The default Marshal coder instance.
				DEFAULT = self.new
			end
		end
	end
end
