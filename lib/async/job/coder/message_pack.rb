# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2024-2025, by Samuel Williams.
# Copyright, 2025, by Shopify Inc.

require "msgpack"

module Async
	module Job
		module Coder
			# Represents a coder that uses MessagePack for job serialization.
			# MessagePack provides fast, compact serialization that is language-agnostic,
			# making it suitable for cross-language job processing systems.
			class MessagePack
				# Initialize a new MessagePack coder with custom type registrations.
				# Registers Symbol and Time types for proper serialization.
				def initialize
					@factory = ::MessagePack::Factory.new
					
					@factory.register_type(0x01, Symbol)
					
					@factory.register_type(0x02, Time,
						packer: ::MessagePack::Time::Packer,
						unpacker: ::MessagePack::Time::Unpacker
					)
				end
				
				# Serialize a job object using MessagePack.
				# @parameter job [Object] The job object to serialize.
				# @returns [String] The serialized job data.
				def dump(job)
					@factory.pack(job)
				end
				
				# Deserialize job data using MessagePack.
				# @parameter data [String] The serialized job data.
				# @returns [Object] The deserialized job object.
				def load(data)
					@factory.unpack(data)
				end
				
				# @attribute [Async::Job::Coder::MessagePack] The default MessagePack coder instance.
				DEFAULT = self.new
			end
		end
	end
end
